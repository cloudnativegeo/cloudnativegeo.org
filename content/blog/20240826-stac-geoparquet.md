+++
date = "2024-08-08T00:00:01-01:00"
title = "Introduction to stac-geoparquet"
tags = [ "STAC", "geoparquet" ]
summary = "An introduction tac-geoparquet."
author = "[Tom Augspurger](https://tomaugspurger.net), [Kyle Barron](https://kylebarron.dev), and [Chris Holmes](https://beta.source.coop/cholmes)"

+++

This post introduces stac-geoparquet, a specification and library for storing and serving [STAC] metadata as [GeoParquet]. By building on GeoParquet, stac-geoparquet makes it easy to store, transmit, and analyze large collections of STAC items. It makes for a nice complement to a STAC API.

## STAC Background

SpatioTemporal Asset Catalog, or [STAC], makes geospatial data queryable, especially "semi-structured" geospatial data like a collection of COGs from a satellite. I can't imagine trying to work with this type of data without a STAC API.

Concretely, STAC metadata consists of JSON documents describing the actual assets (Cloud-Optimized GeoTIFF ([COG]) files, for example). STAC metadata can typically be accessed in two ways:

1. Through a [static STAC catalog](https://github.com/radiantearth/stac-spec/blob/master/catalog-spec/catalog-spec.md), which is just a JSON document linking to other JSON documents (STAC Collections and / or STAC Items, which include the links to the assets)
2. Through a [STAC API](https://github.com/radiantearth/stac-api-spec), which also enables things like search.

In practice, I haven't encountered much data distributed as static STAC catalogs. It's perhaps useful in some cases, but for large datasets or datasets that are constantly changing, a pile of JSON files becomes slow and impractical for both the data provider and consumer. You almost need a STAC API for this type of data.

That said, *running* a STAC API is a hassle (speaking from experience here). You need some kind of [database](https://github.com/stac-utils/pgstac) to store the STAC metadata and [web servers](https://github.com/stac-utils/stac-fastapi) to handle the API requests. That database and those web servers need to be deployed, monitored, and maintained.

Finally, with either a static STAC catalog or an API, for large collections of STAC items you're moving around *a lot* of JSON. That's slow for the web servers to serialize, slow to send over the network, and slow to deserialize on your end.

## Enter STAC-geoparquet

STAC-geoparquet offers a nice format for easily and efficiently storing, transferring, and querying large amounts of *homogenous* STAC items.
The basic idea is to represent a STAC collection as a GeoParquet dataset​​, where each column is a field from the STAC item (`id`, `datetime`, `eo:cloud_cover`, etc.) and each row is an individual item.

The [stac-geoparquet specification](https://stac-utils.github.io/stac-geoparquet/latest/spec/stac-geoparquet-spec/) describes how to convert between a set of STAC items and GeoParquet.

stac-geoparquet optimizes for certain use cases by leveraging the strengths of the [Apache Parquet] file format, at the cost of some generality.
Parquet is a columnar file format, so all the records in a stac-geoparquet dataset need to have the same schema. The more homogenous the items, the more efficiently you'll be able to store them. In practice, this means that all the items in a collection should have the same properties available. This is considered a best practice in STAC anyway, but there may be some STAC collections that can't be (efficiently) stored in stac-geoparquet. This is discussed in detail in [Schema Considerations].

stac-geoparquet (and Parquet more generally) is optimized for bulk and analytic use cases. Tabular data analysis libraries (like [pandas], [Dask], [DuckDB], etc.) can read and efficiently query parquet datasets. In particular, the parquet file format’s support for statistics and partitioning can make certain access patterns extremely fast. A stac-geoparquet dataset might be partitioned by time and space (using a quadkey, for example), letting you efficiently load subsets of the items. And parquet is a columnar file format, so loading a subset of columns is fast and easy. These aspects of the file format pair nicely with cloud-native workflows, where HTTP range requests mean that you don’t even need to download data that your workflow would just filter out anyway.

You likely wouldn't want to do "point" reads, where you look up an individual item by ID, from a stac-geoparquet dataset. Databases like Postgres are much better suited for that type of workload.

And while stac-geoparquet might not be a good on-disk format for a STAC API serving many small queries, it can still play an important role as a transmission format for queries returning large result sets. If a user makes a request that returns many items, it will be faster to transmit those results as stac-geoparquet rather than JSON, thanks to parquet’s more efficient compression and serialization options.

One neat feature is the ability to embed the Collection metadata in the parquet file's metadata. This gives you a great single-file format for moving around small to medium sized collections (large collections may need to be partitioned into multiple files, but can still be treated as a single dataset by parquet readers).

In summary, JSON and Parquet are very different file formats that are appropriate for different use-cases. JSON is record oriented, while Parquet is column oriented. JSON is flexible with respect to types and schemas, while Parquet is strict (which can make building a stac-geoparquet dataset from a collection of STAC items difficult). stac-geoparquet inherits all these properties, which affects the use-cases it’s appropriate for.

## Example

As a simple example, we'll look at what it takes to access one month's worth of sentinel-2-l2a items from the Planetary Computer's [sentinel-2-l2a collection](https://planetarycomputer.microsoft.com/dataset/sentinel-2-l2a). January, 2020 had about 267,880 items.

With some clever code to parallelize requests to the STAC API, we can fetch those items in about 160 seconds.

```python
>>> t0 = time.time()
>>> futures = [search(client, period) for period in periods]
>>> features_nested = await asyncio.gather(*futures)
>>> features = list(itertools.chain.from_iterable(features_nested))
>>> t1 = time.time()
>>> print(f"{t1 - t0:0.2f}")
162.16
```

The `search` method is a couple dozen lines of moderately complex, async Python. Out of curiosity, I serialized that to disk as (uncompressed) ndjson, and it took up about 4.5 GB of space.

With the [`stac-geoparquet`] Python library, we can convert the JSON items to geoparquet:

```python
>>> import stac_geoparquet
>>> rbr = stac_geoparquet.arrow.parse_stac_items_to_arrow(features)
>>> stac_geoparquet.arrow.to_parquet(rbr, "sentinel-2-l2a.parquet")
```

That takes only 260 MB on disk. It can be read with a simple:

```python
>>> table = pyarrow.parquet.read_table("sentinel-2-l2a.parquet")
```

which finishes in just under 5 seconds. That's not entirely a fair comparison to the 160 seconds from the API, since I'm loading that from disk rather than the network, but there's ample room to spare.

The stac-geoparquet Python library can also write to the [Delta] Table format.

Once in GeoParquet, various clients can query the dataset. If you’re a fan of SQL, [duckdb] supports reading Parquet files:

```sql
$ duckdb
D select * from 'sentinel-2-l2a.parquet' where "eo:cloud_cover" < 10 limit 10;
```

Or using [ibis] we can get the average cloudiness per platform for each hour:

```python
>>> counts = (
...     ibis.read_parquet("sentinel-2-l2a.parquet")
...     .group_by(
...         _.platform,
...         hour=_.datetime.truncate("h")
...     ).aggregate(cloud_cover=_["eo:cloud_cover"].mean(), count=_.count())
...     .order_by(["platform", "hour"])
... )
┏━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━┓
┃ platform    ┃ hour                ┃ cloud_cover ┃ count ┃
┡━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━┩
│ string      │ timestamp           │ float64     │ int64 │
├─────────────┼─────────────────────┼─────────────┼───────┤
│ Sentinel-2A │ 2020-01-01 02:00:00 │   63.445030 │   192 │
│ Sentinel-2A │ 2020-01-01 04:00:00 │   26.992815 │    57 │
│ Sentinel-2A │ 2020-01-01 05:00:00 │   72.727221 │    95 │
│ Sentinel-2A │ 2020-01-01 06:00:00 │    0.097324 │    10 │
│ Sentinel-2A │ 2020-01-01 07:00:00 │   54.984660 │   131 │
│ Sentinel-2A │ 2020-01-01 10:00:00 │   48.270195 │   161 │
│ Sentinel-2A │ 2020-01-01 11:00:00 │   97.241751 │    27 │
│ Sentinel-2A │ 2020-01-01 12:00:00 │   70.159764 │   131 │
│ Sentinel-2A │ 2020-01-01 14:00:00 │   47.591773 │   388 │
│ Sentinel-2A │ 2020-01-01 15:00:00 │   50.362548 │   143 │
│ …           │ …                   │           … │     … │
└─────────────┴─────────────────────┴─────────────┴───────┘
```

## Summary

So, in all stac-geoparquet offers a very convenient and high-performance way to distribute large STAC collections, provided the items in that collection are pretty homogenous (which they probably should be, for your users' sake). It by no means replaces the need for a STAC API in all use cases. Databases like Postgres are *really* good at certain workloads. stac-geoparquet complements a STAC API, by handling the bulk-access use-case that a typical JSON-based REST API struggles with. And if you just need to distribute a relatively static collection of STAC items, putting stac-geoparquet on Blob Storage strikes a really nice balance between hardship for the producer and usefulness for the consumer.

[`stac-geoparquet`]: https://stac-utils.github.io/stac-geoparquet/latest/
[Apache Parquet]: https://parquet.apache.org
[Dask]: https://dask.org
[Delta]: https://docs.delta.io/latest/delta-intro.html
[DuckDB]: https://duckdb.org
[geoparquet]: https://geoparquet.org
[ibis]: https://ibis-project.org
[pandas]: https://pandas.pydata.org
[Schema Considerations]: https://stac-utils.github.io/stac-geoparquet/latest/schema/
[STAC]: https://stacspec.org
[COG]: https://www.cogeo.org