+++
date = "2023-10-10T17:17:00-07:00"
title = "Where is COG for Vector?"
tags = [ ""
]
summary = "Cloud-Optimized GeoTIFF for the other half of geodata"
author = "Brandon Liu"
author_url = "https://bdon.org/about/"
author_title = "Radiant Earth Technical Fellow"
draft = "true"
+++

In March, Jed described the ["Na&iuml;ve Origins of Cloud Optimized GeoTIFF"](https://radiant.earth/blog/2023/03/the-naive-origins-of-the-cloud-optimized-geotiff/) &ndash; an access pattern and ecosystem that revolutionized data delivery for AWS, its customers, and the public sector.

COG is an established technology for producing and consuming imagery, but **there's a missing half of geospatial: vector data.** Organizations that work with imagery are wrangling vectors on the side: consider building footprints, tasking areas, parcels, agricultural plots, and ML labels. COG's accessibility advantages *ought* to carry over to vector workflows.

## What makes COG special?

The key differences between COG and Regular Old GeoTiff are its **internal tiling and overviews.**

- **Internal tiling** enables clients to access the parts they need instead of the whole file, a "window" or area of interest.
- **Overviews** are key for enabling the *astronaut's eye view* of entire datasets. Downloading an overview over HTTP can take less than a second, instead of transferring the entire dataset.

This combination permits access via HTTP Range Requests on commodity object storage, making applications simple to build and deploy.

The last "killer feature" of COG is **backwards compatibility**. Adoption is effortless, since applications that read GeoTIFF, read COG. However, this legacy affordance precludes COG's use for vectors.

## Cloud-Native Vector Formats: FlatGeobuf, GeoParquet

Two emerging and complementary solutions for cloud-native vector are FlatGeobuf and GeoParquet.

- [FlatGeobuf](http://flatgeobuf.org) is a row-oriented file format for OGC Features developed by Björn Harrtell. Consider it a "[Shapefile](http://switchfromshapefile.org) that doesn't stink". It has cloud-friendly design elements: the internal organization allows efficient HTTP Range Requests. It has spatial index for remote reads to access a subset of rows.
- GeoParquet differs from FlatGeobuf in its **columnar layout**. This can achieve smaller datasets since similar feature attributes can be compressed together in blocks. It's ideal for access patterns that scan the entire feature set. See Chris Holmes' post on the [GeoParquet 1.0.0 spec](https://cloudnativegeo.org/blog/2023/09/geoparquet-1.0.0-released/). Like COG, it has "free" interoperability with popular tools like DuckDB.

## Limitations

Both FlatGeobuf and GeoParquet qualify as **cloud-native vector formats**. If we compare their advantages to COG, their designs have neither **internal tiling nor overviews.** Why does this matter? 

If a dataset consists of points, or uniformly-sized polygons like buildings, a spatial index is as good as internal tiling. But a dataset with irregularly sized features does not have a practical equivalent. If a single feature contains 10,000 vertices &ndash; like the complex boundary of a protected wildlife area &ndash; any queries that touch this feature fetch the entire vertex sequence.

(Illustration)

Tiling a COG is obvious, since the pixels are gridded. But tiling of a vector dataset involves non-trivial clipping of polygons into bite-sized parts.

(Illustration)

What about overviews? COG has an obvious strategy: each overview downsamples by 2, with a well-known resampling algorithms (bilinear, bicubic, Lanczos...). 

(Illustration)

*What is an overview for vector?* It's essential for the astronaut's eye view &ndash; a view of the "whole dataset" on a map. The solutions are ad-hoc: you could create duplicate, simplified versions of every feature and attributes specifying which zoom level to appear at. But that approach doesn't solve which *features to eliminate*, since including every feature in a million-row dataset for zoom 0 is impossible. 

(Illustration)

FlatGeobuf and GeoParquet are **analysis-focused formats.** They're useful for answering queries like *What is the sum of attribute A over features that overlap this polygon?* But their fundamental design does not enable **cloud-native visualization** like COG does. 

## The Vector Tile

Tiling and overviews of vector data is best accomplished with **vector tiles.** The de-facto standard, implemented by PostGIS and GDAL, is the [open MVT specification](https://github.com/mapbox/vector-tile-spec) by MapBox &ndash; an SVG-like format using Protocol Buffers.

The best-in-class tool for creating vector tiles from datasets like FlatGeobuf and GeoParquet is [tippecanoe](https://github.com/felt/tippecanoe), originally developed by MapBox, but since v2.0 maintained by Felt. Tippecanoe doesn't just slice features into tiles, it generates smart **overviews** for every zoom level matching a typical web mapping application. It adaptively simplifies and discards features, using [a plethora of configuration options](https://github.com/felt/tippecanoe#cookbook), to assemble a coherent "astronaut's eye view" of entire datasets with minimal tile weight. 

The last missing piece is a cloud-friendly organization of tiles enabling efficient spatial operations. This is the focus of my [PMTiles](https://github.com/protomaps/PMTiles) project, an open specification for COG-like pyramids of tiled data, suited to planet-scale vector mapping. PMTiles, along with other nascent designs such as [TileBase](https://github.com/openaddresses/TileBase) and [COMTiles](https://github.com/mactrem/com-tiles), work straight-to-the browser, meaning they're a great fit for vector data referenced through [SpatialTemporal Asset Catalogs.](https://stacspec.org)

## Walkthrough

Chris Holmes' [Google Open Buildings dataset on Source Cooperative](https://beta.source.coop/cholmes/google-open-buildings) contains GeoParquet files for different administrative regions. 

Using Planet's [gpq](https://github.com/planetlabs/gpq) command line tool in concert with Tippecanoe:

`gpq convert Cairo_Governorate.parquet --to=geojson | tippecanoe Cairo.geojson -o Cairo.pmtiles`

The 105 MB GeoParquet input gets turned into a 54MB PMTiles archive, which can then be dropped directly into the [PMTiles Viewer](https://protomaps.github.io/PMTiles/):

(illustration)

This 54MB archive can be stored on S3 and enables simple deployment of interactive visualizations &ndash; a useful complement to analysis-focused vector formats.