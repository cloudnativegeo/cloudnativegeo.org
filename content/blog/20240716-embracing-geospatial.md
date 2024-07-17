+++
date = "2024-07-15T00:00:01-07:00"
title = "Embracing Geospatial as a Primary Data Type: A Call to Action for the Data Community"
tags = [ ""
]
summary = "Chris Holmes and Javier de la Torre argue for geospatial data to move from a niche concern requiring specialized tools to a standard data type that can be integrated seamlessly with other data."
author = "Chris Holmes and Javier de la Torre"
+++

{{< img src="images/20240716-embracing-geospatial.png" alt="Embracing Geospatial as a Primary Data Type">}}

Over two years ago, the GeoParquet project brought together a diverse group of interests around a clear objective: standardizing how geospatial data is used within Parquet. The initial goal was modest: to ensure that any tool reading or writing spatially located geometries (points, lines and polygons) does so in a consistent and interoperable way. But the ultimate goal of the effort has been to make geospatial a primary data type within the broader data community, thereby breaking the ‘GIS’ data silo and enabling the seamless integration of geospatial data with all other data types. We envision a world where spatial data is simply another column in your dataset, not a special case requiring unique handling. This integration will unlock new insights, reduce the need for specialized tools, and make geospatial information accessible to a broader range of users and innovations.
Without standardization, the current situation is that geospatial datasets are often non-interoperable. Spatial data might be a column in each system, but moving data between systems requires extensive overhead to transform it properly due to insufficient metadata. Naively adding geospatial types to big data systems often leads to poor performance because the necessary metadata and indexes for effective spatial operations are not considered. This fragmentation and inefficiency highlight the urgent need for standardized approaches.

### Progress and Adoption
Since its inception, the GeoParquet group has launched versions 1.0 and 1.1, witnessing significant adoption across various tools ([over 20 tools and libraries implement the specification](https://geoparquet.org/#implementations)) and datasets.

One of the main design goals for the GeoParquet specification was to make it as easy as possible for a non-geospatial expert to implement, while also providing the ability to properly handle any of the obscure requirements that geospatial experts need for critical applications. If someone has a bunch of longitude and latitude GPS points they should be easily able to figure out how to store them in GeoParquet without having to understand coordinate reference systems, polygon winding orders and spherical edges. But that point data should work seamlessly when it’s joined with data exported from 3 different national governments who all use different projections, in a system that needs the epoch right because it requires sub-centimeter accuracy in an area where the movement of the continental plates affects the output. 
Getting the right balance of simplicity and complexity for GeoParquet has involved extensive discussion for each of the resulting 8 metadata fields. One major goal for each field was to establish good default values, so that systems that did not have complex requirements could safely ignore them while also naturally doing the right thing when writing out the data. The resulting collection of metadata fields ensures that geospatial data transferred across systems can be fully understood without ambiguity or errors. Our hope is that these fields can be leveraged by other systems who wish to add geospatial support, enabling them to start simple by hardcoding a smaller number of acceptable values, but able to start with the right fields to handle all the nuance of the geospatial world.
Initially, we added this metadata as an extension in the form of a JSON string within the Parquet file metadata, as that was Parquet’s only available extension point. However, with growing interest in geospatial support within the data community, it's time to refine our strategy. Parquet is not alone in the data ecosystem. The rise of open table formats in data lakes and other technologies makes it clear that spatial types need to be fully handled at all layers.

### Moving forward
Last month, we organized a meetup in San Francisco, inviting people working on various technologies like Parquet, Arrow, Iceberg, Delta, and others interested in adding geospatial support. The consensus was the need for a coordinated approach to ensure geospatial types are handled correctly across all levels of the stack, in order to avoid interoperability issues between different layers and necessary transformations.

Currently, groups are working on adding geospatial capabilities to Arrow, Parquet, Iceberg, Delta, etc. Our proposal is to coordinate these efforts. We suggest leveraging the research and discussions from the GeoParquet group, as documented in its specification (with extensive justification for the decisions available in the issues and pull requests). The ideal outcome is that GeoParquet itself becomes unnecessary, with geospatial being treated as a primary data type in all relevant formats and protocols, accompanied by the right metadata.

### A path forward
The tentative conclusion of our meeting in San Francisco was to start with the standardization of [Well-Known Binary](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) (WKB) support in Arrow, Parquet, and Iceberg, representing these as native types across these technologies. This likely consists of three main tasks:
* Complete the work to add a WKB data type to Parquet. Work has [already started](https://github.com/apache/parquet-format/pull/240), but funding is needed to complete it.
* Create an Apache Arrow [Canonical Extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html#official-list) for WKB. The core work for WKB in Arrow is mostly complete in conjunction with [GeoArrow](https://geoarrow.org/), but this will help promote it as a mature, interoperable (but less efficient) encoding option.
* Continue and complete the support for geospatial data in Apache Iceberg through the usage of WKB. There are several threads of collaboration on this, see [this issue](https://github.com/apache/iceberg/issues/2586) for some of the history.

And getting these basics working is just the beginning. The potential of a second phase is to go beyond WKB and align on optimized geometry encodings that fit more directly into the paradigms of modern data formats and protocols, enabling more performance and efficiency in an interoperable way.

Finally, this initial path of interoperability is thus far only focused on geospatial [vector data](https://en.wikipedia.org/wiki/Data_model_(GIS)#Vector_data_model). Similar initiatives will be needed to fit other types of geospatial data such as [raster](https://en.wikipedia.org/wiki/Data_model_(GIS)#Raster_data_model), [point clouds](https://en.wikipedia.org/wiki/Point_cloud), [discrete global grid systems](https://en.wikipedia.org/wiki/Discrete_global_grid) (such as [H3](https://h3geo.org) and [S2](https://s2geometry.io)) into the mainstream data formats & protocols. 

### Call to Action
We call on the community to combine these efforts into a single effort, ensuring all pieces fit together seamlessly. We propose to center this effort around the existing GeoParquet community group, which meets bi-weekly and has already conducted extensive discussions. The task of integrating geospatial types into various data stacks will not be simple, but we have a clear roadmap compatible with all existing initiatives. 

If you are working on geospatial support in any relevant data technology, please consider joining the GeoParquet meetup group (suggestions are welcome for a new name that reflects the broader collaboration) and collaborate with others - just email requests [at] geoparquet.org and ask to be added to the calendar invite. Now that geospatial is being added to many standards and protocols, we have the opportunity to coordinate our efforts and establish robust geospatial support from the start, reducing frictions and limitations for years to come. 

Interested in seeing this happening and can provide financial support? We also want to hear from you. There is already some initial funding available from OGC, sponsored by Planet and CARTO, to push forward Iceberg support for geospatial.

The future for geospatial is bright! Let's work together to ensure it integrates seamlessly into the broader data ecosystem.

### Relevant links and initiatives
* GeoParquet: [geoparquet.org](https://geoparquet.org)
* GeoArrow: [geoarrow.org](https://geoarrow.org/)
* Geo on Iceberg: [geo on iceberg github issue](https://github.com/apache/iceberg/issues/2586)

Checkout the notes from the San Francisco Meeting: [GeoParquet in person meetup at Data + AI conference](https://docs.google.com/document/d/1Dj9F8185qmrz2CpEvgKDlXQkHpBL8CjqGy_JS-hMetI/edit#heading=h.d8n988fv1mve) 
