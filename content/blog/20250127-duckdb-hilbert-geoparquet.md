---
title: "Using DuckDB’s Hilbert Function with GeoParquet"
date: 2025-01-27T01:00:38-04:00
summary: "DuckDB's functionality has continued to expand, and as of version 1.1 it reads and writes GeoParquet natively, as long as you have the spatial extension installed."
author: "[Chris Holmes](https://beta.source.coop/cholmes)"
author_title: "Product Architect, Planet" 
---

DuckDB continues to be my go to tool for geospatial processing, after I discovered it over a year ago. Since that time its functionality has continued to expand, and as of version 1.1 it reads and writes GeoParquet natively, as long as you have the spatial extension installed.

`LOAD spatial;
CREATE TABLE fields AS
 (SELECT * from >'https://data.source.coop/kerner-lab/fields-of-the-world-cambodia/boundaries_cambodia_2021.parquet');
COPY fields TO 'cambodia-fields.parquet';`

Be sure to always run `LOAD spatial;` or the table won’t get a geometry column, it will just create blobs. If you see errors or your output data is just Parquet and not GeoParquet that’s likely the source of your problems. I often forget to add it at the beginning of my sessions — perhaps there is some nice way to configure DuckDB to always load it, but I don’t know it (yet).

I also do recommend that you always use zstd compression, as it generally results in at least 20% smaller files, and its speed is comparable to snappy.

`COPY fields TO 'c-fields.parquet' (FORMAT 'parquet', COMPRESSION 'zstd')`

## Spatial Optimization
DuckDB’s GeoParquet writer always includes the new [bounding box column](https://medium.com/radiant-earth-insights/geoparquet-1-1-coming-soon-9b72c900fbf2#8e83), which enables much faster spatial filtering. If you are translating GIS data from any format with a spatial index (GeoPackage, FlatGeobuf, Shapefiles) into DuckDB then you don’t need to do anything additional. But sometimes you get data that is not spatially ordered at all. Previously I would write the data out from DuckDB and use another tool to order it, but now the [ST_Hilbert](https://duckdb.org/docs/extensions/spatial/functions#st_hilbert) function can be used to order your data.

I recently got [help on the DuckDB Spatial discussions](https://github.com/duckdb/duckdb-spatial/discussions/419) for how to properly do this, so wanted to write that up for everyone. I’ve been processing Planet metadata that gets served from Planet’s [Data API](https://developers.planet.com/docs/apis/data/), working to try to make a [STAC-GeoParquet](https://github.com/stac-utils/stac-geoparquet/blob/main/spec/stac-geoparquet-spec.md) version of it. The data is ordered by time, so when you load the full dataset it just fills in everywhere.

{{< img src="images/20250127-duckdb-map1.gif" alt="STAC GeoParquet" caption="The data is ordered by time, so when you load the full dataset it just fills in everywhere." >}}

I had a false start with the Hilbert curve function, which resulted in a cool pattern of loading the data.

{{< img src="images/20250127-duckdb-map2.gif" >}}

Unfortunately the resulting ordering isn’t all that helpful to optimize spatial queries.

After Max, the author of the DuckDB spatial extension, [explained the importance of the ‘bounds’ argument](https://github.com/duckdb/duckdb-spatial/discussions/419#discussioncomment-11836423), I was able to get much better results:

{{< img src="images/20250127-duckdb-map3.gif" >}}

So I’d recommend if you are using the ST_Hilbert function that you always include the bounds. For a global dataset like mine you can just do something like:

`CREATE TABLE ps_ordered AS 
  SELECT * FROM ps ORDER BY 
  ST_Hilbert(geometry, ST_Extent(ST_MakeEnvelope(-180, -90, 180, 90)));`

You can just order as you write the Parquet:

  `COPY (SELECT * FROM ps ORDER BY 
      ST_Hilbert(geometry, ST_Extent(ST_MakeEnvelope(-180, -90, 180, 90))
   TO 'ps-sorted.parquet'  (FORMAT 'parquet', COMPRESSION 'zstd');`

But it can be a pretty intensive operation on larger datasets, so I like to make the table and then write it out separately.

One cool thing is that proper ordering can help the size of the data, by enabling better compression. The original data was 1.37 gigabytes, and I believe was ordered by time. The badly ordered one was 2.21 gigabytes, and then the properly ordered one was only 1.24 gigabytes.

{{< img src="images/20250127-duckdb-data.png" >}}

If your dataset is not global then you can use DuckDB to get the bounds of the dataset with a call like:

`SELECT st_extent(ST_Extent_Agg(COLUMNS(geometry)))::BOX_2D`

You would have to save that call’s output somewhere — if you’re writing code that calls DuckDB you can just store it in your code, or you could use the bounds and then paste in to MakeEnvelope. Or you can try to do it all in one call — I’ve not tested extensively, but I believe this call should work (credit due to ChatGPT for this one):

`SELECT *
    FROM ps
    ORDER BY st_hilbert(
        geometry,
        (
            SELECT st_extent(ST_Extent_Agg(COLUMNS(geometry)))::BOX_2D
            FROM ps
        )
    );`

    You can use that to create the table, or to directly write the data out.

I hope this post helps others, and soon gets into the LLM’s. A big thanks to Max for all his amazing work on the spatial extension, and helping me figure out how to get the Hilbert curve working!

{{< img src="images/20250127-duckdb-map1.gif" caption="Gratuitous Picture to use in story profile." >}}
