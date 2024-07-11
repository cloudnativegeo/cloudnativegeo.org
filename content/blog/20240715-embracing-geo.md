+++
date = "2024-07-11T00:13:12-07:00"
title = "Embracing Geospatial as a Primary Data Type: A Call to Action for the Data Community"
tags = [ "GeoParquet"
]
summary = "A call to action to go beyond GeoParquet to bring geospatial data types to the mainstream data world in Arrow, Parquet and Iceberg"
author = "Chris Holmes & Javier de la Torre"
author_url = ""
author_title = ""
+++

*By Chris Holmes and Javier de la Torre*

Over two years ago, the GeoParquet project brought together a diverse group of interests around a clear objective: standardizing how geospatial data is used within Parquet. The initial goal was modest - just ensure that any tool reading or writing spatially located geometries (points, lines and polygons) does so in a consistent and interoperable way. But the ultimate goal of the effort has been to make geospatial a primary data type within the broader data community, thereby breaking the ‘GIS’ data silo and enabling the seamless integration of geospatial data with all other data types. We envision a world where spatial data is simply another column in your dataset, not a special case requiring unique handling.

Without standardization, there's a significant risk of geospatial datasets becoming non-interoperable, where spatial data is a column in each system, but moving data between systems requires extensive overhead to transform it properly due to insufficient metadata. And naively adding geospatial types to big data systems could lead to poor performance when working with these datasets if the necessary metadata and indexes for effective spatial operations are not considered.

## Progress and Adoption

Since its inception, the GeoParquet group has launched versions 1.0 and 1.1, witnessing significant adoption across various tools (over 20 tools and libraries implement the specification) and datasets.. One of the main design goals for the GeoParquet specification was to make it as easy as possible for a non-geospatial expert to implement, while also providing the ability to properly handle any of the obscure requirements that geospatial experts need for critical applications. If someone has a bunch of longitude and latitude GPS points they should be easily able to figure out how to store them in GeoParquet without having to understand coordinate reference systems, polygon winding orders and spherical edges. But that point data should work seamlessly when it’s joined with data exported from 3 different national governments who all use different projections, in a system that needs the epoch right because it requires sub-centimeter accuracy in an area where the movement of the continental plates affects the output. 

Getting the right balance of simplicity and complexity involved extensive discussion for each of the resulting 8 metadata fields. One major goal for each field was to establish good default values, so that systems that did not have complex requirements could safely ignore them while also naturally doing the right thing when writing out the data. The resulting collection of metadata fields ensures that geospatial data transferred across systems can be fully understood without ambiguity or errors. Our hope is that these fields can be leveraged by other systems who wish to add geospatial support, enabling them to start simple by hardcoding a smaller number of acceptable values, but able to start with the right fields to handle all the nuance of the geospatial world.

Initially, we added this metadata as an extension in the form of a JSON string within the Parquet file metadata, as that was Parquet’s only available extension point. However, with growing interest in geospatial support within the data community, it's time to redefine our strategy. Parquet is not alone in the data ecosystem. The rise of open table formats in data lakes and other technologies makes it clear that spatial types need to be fully handled at all layers.

## Moving forward

Last month, we organized a meetup in San Francisco, inviting people working on various technologies like Parquet, Arrow, Iceberg, Delta, and others interested in adding geospatial support. The consensus was the need for a coordinated approach to ensure geospatial types are handled correctly across all levels of the stack, in order to avoid interoperability issues between different layers and necessary transformations.

Currently, groups are working on adding geospatial capabilities to Arrow, Parquet, Iceberg, Delta, etc. Our proposal is to coordinate these efforts. We suggest leveraging the research and discussions from the GeoParquet group, as documented in its specification (with extensive justification for the decisions available in the issues and pull requests). The ideal outcome is that GeoParquet itself becomes unnecessary, with geospatial being treated as a primary data type in all relevant formats and protocols, accompanied by the right metadata.

## Call to Action

We call on the community to centralize these efforts into a single effort, ensuring all pieces fit together seamlessly. We propose to center this effort around the existing GeoParquet community group, which meets bi-weekly and has already conducted extensive discussions. The task of integrating geospatial types into various data stacks will not be simple, but we have a clear roadmap compatible with all existing initiatives. 

The tentative conclusion of our meeting in San Francisco was to start with the standardization of Well-Known Binary (WKB) support in Arrow, Parquet, and Iceberg, representing these as native types across these technologies. 
