+++
date = "2023-09-18T05:11:16-07:00"
title = "GeoParquet 1.0.0 Released"
tags = [ ""
]
summary = "The GeoParquet community is pleased to announce the release of GeoParquet 1.0.0."
author = "Chris Holmes"
author_url = "https://beta.source.coop/cholmes"
author_title = "Radiant Earth Technical Fellow"
+++

The GeoParquet community is pleased to announce the release of [GeoParquet 1.0.0](https://geoparquet.org/releases/). This is a huge milestone, indicating that the format has been implemented and tested by lots of different users and systems and the core team is confident that it is a stable foundation that won’t change. There are more than 20 different libraries and tools that support the format, and hundreds of gigabytes of public data is available in GeoParquet, from a number of different data providers.

## Why GeoParquet?
I gave a good bit of the backstory in the [beta.1 announcement](https://cholmes.medium.com/geoparquet-1-0-0-beta-1-released-6390ecb4c6d0), but the main driving push has been to settle on one standard way to encode geometries in the Apache [Parquet](https://parquet.apache.org/) format. The immediate goal has been to enable spatial interoperability among the set of modern data science tools (BigQuery, Snowflake, Athena, DuckDB, etc) that leverage Parquet to great effect and increasingly have geospatial support. Though most of those do not yet support GeoParquet it is likely on many of their roadmaps, and providing the stable base of 1.0.0 should make it even easier for them to adopt.

But in the meantime GeoParquet has emerged as just a great geospatial format, with support in many geospatial libraries and tools, that I think has potential to be a core [Cloud-Native Geospatial](https://cloudnativegeo.org/) distribution format and a go to for any day to day geospatial work.

### Faster and Smaller
The core reason it’s becoming everyone’s favorite new format is that it’s simply faster and smaller than the competition. I wrote a blog on some testing I did [exploring write performance and file size](/blog/2023/08/performance-explorations-of-geoparquet-and-duckdb/), and intend to make some testing tools for read performance as well. For those that don’t want to read the full post, a typical file size comparison is:

{{< img src="images/20230914-filesizes.png" alt="chart showing the GeoParquet file sizes are typically smaller than shp, gpkg, or fgb" caption="" >}}

The main reason for this is that Parquet is compressed by default. The other formats can be zipped up, but then they aren’t actually usable until you unzipped them. GeoParquet’s speed is also quite impressive compared to other formats, mostly due to the fact that it’s a columnar format instead of a row-oriented one, and has an large ecosystem of tools that have really optimized its performance.

## The GeoParquet Ecosystem
I think the most impressive thing about GeoParquet is how robust the ecosystem has become, before we even got to 1.0.0. I fully believe this is just the start, and that in no time at all it’ll be weird for a geospatial tool to not support GeoParquet, and many non-geo tools will have it as their only native geospatial option. I’ll do a full post on the amazing ecosystem soon, but you can get a quick sense from the list of [tools and libraries on geoparquet.org](https://geoparquet.org/#implementations):

{{< img src="images/20230914-tools.png" alt="A screenshot showing tools and libraries that support GeoParquet from geoparquet.org" caption="" >}}

We’re also starting to see data providers like Microsoft, Maxar, Planet, Ordnance Survey and others put new data in GeoParquet. And the community is also converting a number of interesting large scale datasets like the [Google Open Buildings](https://beta.source.coop/repositories/cholmes/google-open-buildings/description) and [Overture Maps](https://beta.source.coop/cholmes/overture) data to [GeoParquet on Source Cooperative](https://beta.source.coop/repositories?tags=geoparquet).

## What’s next?
The release of 1.0.0 is truly just the beginning. We’re taking it through the full Open Geospatial Consortium’s standardization process, as we’ve started forming an official [GeoParquet Standards Working Group](https://portal.ogc.org/files/103450). We hope to move through the standardization process relatively quickly, to become an full official OGC Standard.

There is also a lot of activity on the [GeoArrow](https://geoarrow.org/) specification, which will form the basis of a columnar geometry format for GeoParquet 1.1.0. That has a lot of potential to make the format and tools around it even more performant.

We’re excited to see this community grow, with more data, more tools and more innovation. Please help us by converting data into GeoParquet, demanding GeoParquet from your data providers, and building tools to make use of it. And let us know when you do, so everyone can keep track of the growth of this exciting community.