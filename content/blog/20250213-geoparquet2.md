+++
date = "2025-02-13T00:00:01-01:00"
title = "Geoparquet 2.0: Going Native"
tags = [ ""
]
summary = "GeoParquet 2.0 introduces native GEOMETRY and GEOGRAPHY support in Parquet and Iceberg, marking a major milestone in geospatial data integration and interoperability."  
author = "Chris Holmes, Joris Van den Bossche, Jacob Wasserman, Jia Yu, Kyle Barron, Tim Schaub, Javier de la Torre"  
+++

{{< img src="images/20250213-parquet_iceberg_new_geo_data_types.png" alt="New geo data types in Parquet and Iceberg">}}


Seven months ago, we issued [A Call to Action for the Data Community](https://cloudnativegeo.org/blog/2024/07/embracing-geospatial-as-a-primary-data-type-a-call-to-action-for-the-data-community/) to break down geospatial data silos and make GIS a core part of analytics. Today, we're thrilled to announce two major developments that bring this vision closer to reality:

-   The Parquet specification has [officially adopted](https://github.com/apache/parquet-format/blob/94b9d631aef332c78b8f1482fb032743a9c3c407/Geospatial.md?plain=1#L27) geospatial guidance, enabling native storage of GEOMETRY and GEOGRAPHY types

-   Iceberg 3 now includes GEOMETRY and GEOGRAPHY as part of its [official specification](https://github.com/apache/iceberg/blob/main/format/spec.md)  

Now both Parquet and Iceberg support columns of type GEOMETRY or GEOGRAPHY just like INT32, INT64, FLOAT32, etc. columns! Yay! This is a landmark achievement for geospatial data! 🎉
  
## A Community Achievement

First, a heartfelt thank you to everyone who contributed to this effort—engineers, early adopters, and advocates who pushed for geospatial data to be treated as a first-class citizen. This milestone wasn't achieved overnight; it took years of collaboration across organizations and ecosystems. From the early days of GeoParquet 1.0 to today's native Parquet support, this progress demonstrates the power of open-source community action.

# What's Changing with GeoParquet 2.0

The GeoParquet initiative has always aimed to make geospatial data "boringly interoperable." With Parquet and Iceberg now supporting geometry types natively, GeoParquet is entering its next phase.

-   GeoParquet 1.0/1.1: Parquet files with additional metadata to "label" geometries/geographies
    
-   GeoParquet 2.0: Regular Parquet files utilizing native GEOMETRY and GEOGRAPHY data types

Recommendations for Implementation

While native support represents the future of geospatial data storage, adoption will take time. We recommend:

-   Continuing with GeoParquet 1.1 for production systems until tools fully support Parquet's native geospatial types. A few pioneer implementations have started.  
      
-   Planning for eventual migration to GeoParquet 2.0  
      
-   Following our upcoming migration guides and best practices and some discussions on exact differences between versions. In an ideal world we would make Geoparquet 2.0 files also be compatible with 1.1 and 1.0, stay tuned for that.
    
## What’s Next for the Spec?

While achieving native geometric type support is a significant milestone, our work isn't finished. Our immediate focus areas include:

-   Developing best practices for GeoParquet 2.0 implementation
    
-   Creating clear transition guidelines from previous versions
    
-   Establishing standards for CRS handling and performance optimization
    
-   Continuing outreach and advocacy for widespread adoption
    
# Beyond Vector Data

This is just the beginning of modernizing geospatial data storage. We're already looking ahead to other types of geospatial data such as raster, point cloud, spatial indexes…

The journey to truly integrated geospatial analytics continues, but with GeoParquet 2.0, we've taken a major step forward. Stay tuned for more updates and guidance as we work toward making geospatial data a natural part of every analytics stack. And if you’d like to be more involved we’ll be working in the [GeoParquet GitHub repo](https://github.com/opengeospatial/geoparquet). We also run bi-weekly meetings on advancing geospatial in Parquet, Iceberg and Arrow, just join the [geoparquet-community group](https://groups.google.com/a/cloudnativegeo.org/g/geoparquet-community) and you’ll be added to the calendar. And we’re also starting up a meeting for implementors of geospatial in Iceberg to share best practices and work through any issues.