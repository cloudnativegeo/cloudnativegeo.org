+++
date = "2023-09-26T05:47:12-07:00"
title = "Introducing the ultimate cloud-native building footprints dataset"
tags = [ ""
]
summary = "The most comprehensive, freely available, global, cloud-native building footprint dataset available today on Source Cooperative."
author = "Mike Mahoney"
author_url = "https://www.linkedin.com/in/darellvdv"
author_title = "Data & Cloud Engineer at VIDA"
+++

### One key contribution of geospatial data is building footprints — outlines of buildings as identified by satellite. These are invaluable to planners, governments, investors and even disaster relief efforts. Industry leaders Google and Microsoft both recently released some revolutionary new building footprint datasets — including billions of buildings worldwide. These were generated using advanced machine learning on high-resolution satellite images.

Now, at VIDA, we’ve taken it a step further. We’re excited to share that by merging the Google and Microsoft datasets, we’ve created the most comprehensive, freely available, global, cloud-native building footprint dataset available today. It’s hosted on the [Source Cooperative](https://beta.source.coop/) and accessible on [map.vida.place/explore](https://map.vida.place/explore).

{{< img src="images/20230926-cn-building-footprints.png" alt="Source Cooperative" caption="The dataset is freely available for download on Source Cooperative." >}}

### Harnessing BigQuery for geospatial excellence
At VIDA, we rely heavily on BigQuery for handling large-scale geospatial tasks. Given its robust features and efficient processing capabilities, it is our platform of choice.

The VIDA platform is used in more than 20 countries to plan and de-risk sustainable infrastructure investment projects. Amongst commercial building footprint datasets, we routinely use the openly available Google as well as Microsoft building footprint datasets. We have found that for different areas, one or the other dataset was superior.

In order to get the best from both datasets, our goal was to create a unified dataset we could use globally. The challenge was to ensure that overlapping footprints from Microsoft’s dataset, which were already present in Google’s dataset, were excluded.

In geospatial analytics, handling vast amounts of data efficiently is crucial. To achieve this, we employed techniques like spatial clustering and partitioning. Our partitioning was based on administrative level 0 boundaries using the CGAZ dataset. This decision was influenced by the widespread availability of deep-level administrative boundaries and the distribution pattern of building footprints. Read our [blog post](https://medium.com/vida-engineering/blueprints-to-bigquery-a-deep-dive-into-large-scale-spatial-joins-for-building-footprints-c475f6d6f58b) for a more detailed overview on our merging approach.

### Impressive statistics speak for themselves

Our merging endeavor yielded some truly impressive statistics:

- Due to BigQuery’s use of distributed computer power we could merge most countries in under just 30 seconds.
- Microsoft’s dataset contributed an additional 689,703,963 building footprints.
- The final count post-merge stood at a whopping 2,534,595,270 building footprints.
- Our dataset now boasts a coverage of 92% of Administrative boundaries (Level 0), spread across 182 distinct partitions.
- The dataset is comprehensive, featuring geometries, area measurements (in meters), confidence metrics (exclusive to Google footprints), and the source of each footprint.

### Crafting a cloud-native data product: The export journey
While BigQuery offers multiple export formats, the absence of direct GeoParquet support posed a challenge. However, the recent release of [GeoParquet version 1](https://geoparquet.org/releases/v1.0.0/) brings hope for future integrations. To overcome this, we let DuckDB take over the heavy lifting once the data was out of BigQuery and into our GCS buckets. DuckDB’s awesome [httpfs extension](https://duckdb.org/docs/extensions/httpfs) implements a file system that allows reading remote/writing remote files. Although we needed a bit of [workaround](https://duckdb.org/docs/guides/import/s3_import.html), mocking GCS as an S3 URI, the integration worked seamlessly. Using DuckDB we merged and exported the Parquet files based on our partitioning schemes and subsequently utilized [gpq](https://github.com/planetlabs/gpq) and ogr2ogr to craft GeoParquet and FlatgeoBuf files. The final touch was the creation of [PMTiles](https://github.com/protomaps/PMTiles) archives, both at the country and global levels.

While our initial partitioning based on level 1 administrative boundaries was effective and straight-forward, we noticed that some Parquet files were excessively large, affecting performance. Our solution? A combination of administrative level 1 partitioning and further splitting based on the S2 grid. This dual approach, inspired by the [open-buildings](open-buildings) tool from [Chris Holmes](https://www.linkedin.com/in/opencholmes/), ensures optimal performance. Using BigQuery’s native S2_CELLIDFROMPOINT function, we were able to assign each building footprint to a S2 grid ID, making sure no grid exceeded more than 20 million buildings.

### What’s next?
Our integrated dataset is now accessible on Source Cooperative in various formats, including FlatGeoBuf, GeoParquet, and PMTiles. Go check it out at [https://beta.source.coop/vida/google-microsoft-open-buildings](https://beta.source.coop/vida/google-microsoft-open-buildings). We’ve employed a mix of partitioning strategies, focusing on administrative level 0 and a combination of level 0 with S2 grids. You can also view the dataset directly at [map.vida.place/explore](https://map.vida.place/explore), where we use a small serverless middleware to translate the PMTiles archive to a technology agnostic XYZ tile URL. Sign-up is free!

As we continue our work, we plan to refine our partitioning techniques, with a focus on integrating both administrative levels 0 and 1. This approach has already shown promising results in certain test regions. We invite the tech community to explore our dataset and join us in pushing the boundaries of geospatial data analysis!
