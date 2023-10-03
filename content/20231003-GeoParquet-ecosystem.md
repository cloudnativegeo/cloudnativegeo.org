+++
date = "2023-10-03T05:11:16-07:00"
title = "The GeoParquet Ecosystem at 1.0.0"
tags = [ ""
]
summary = "A compilation of GeoParquet-compatible libraries, tools, and data providers offering compelling datasets within the specification"
author = "Chris Holmes"
author_url = "https://beta.source.coop/cholmes"
author_title = "Radiant Earth Technical Fellow"
+++

One of the things I’m most proud of about GeoParquet 1.0.0 is how robust the ecosystem already is. For the [1.0.0 announcement](https://cloudnativegeo.org/blog/2023/09/geoparquet-1.0.0-released), I started to write up all the cool libraries and tools supporting GeoParquet, and the awesome data providers who are already providing interesting data in the spec. But I realized it would at least double the length of the blog post to do it justice, so I decided to save it for its own post.

### The libraries
The core of a great ecosystem is always the libraries, as most tools shouldn’t be writing their own special ways to talk to different formats — they should be able to leverage a well-optimized library so they can spend their time on other things. The first tool to support GeoParquet, before it was even called GeoParquet, was the great [GeoPandas library](https://geopandas.org/en/stable/). They added methods to [read](https://geopandas.org/en/stable/docs/reference/api/geopandas.read_parquet.html) and [write](https://geopandas.org/en/stable/docs/reference/api/geopandas.GeoDataFrame.to_parquet.html) Parquet, and then [Joris Van den Bossche](https://github.com/jorisvandenbossche) and [Dewey Dunnington](https://github.com/paleolimbot) started the process of standardizing the geospatial parquet format as part of [GeoArrow](https://geoarrow.org/) as they explored cross-library reading and writing. Joris wrote the GeoPandas Parquet methods, and Dewey worked in R, working on the [GeoArrow](https://github.com/paleolimbot/geoarrow) R library (there’s also another R library called [sfarrow](https://wcjochem.github.io/sfarrow/index.html)). Their initial work became the core of the GeoParquet spec, with a big thanks to [Tom Augspurger](https://github.com/TomAugspurger) for joining their community with the OGC-centered one where I started. We decided to use the [OGC repo](https://github.com/opengeospatial/geoparquet/) that I was working in for the GeoParquet spec, and to keep the [GeoArrow spec repository](https://github.com/geoarrow/geoarrow) focused on defining Geospatial interoperability in Arrow. Arrow and Parquet are intimately linked, and defining GeoParquet was much more straightforward, so we all agreed to focus on that first.

The next two libraries to come were sponsored by Planet. [Even Rouault](https://www.spatialys.com/en/about/) added drivers for [GeoParquet](https://gdal.org/drivers/vector/parquet.html) and [GeoArrow](https://gdal.org/drivers/vector/arrow.html) to [GDAL/OGR](https://gdal.org/), and while he was at it created the [Column-Oriented Read API for Vector Layers](https://gdal.org/development/rfc/rfc86_column_oriented_api.html). The new API enables OGR to ‘retrieve batches of features with a column-oriented memory layout’, which greatly speeds things up for reading any columnar format. And [Tim Schaub](https://github.com/tschaub) started [GPQ](https://github.com/planetlabs/gpq), a Go library for working with GeoParquet, initially enabling conversion of GeoJSON to and from GeoParquet, and providing validation and description. He also packaged it up into a webapp with WASM, enabling online conversion to and from GeoParquet & GeoJSON. [Kyle Barron](https://kylebarron.dev/) also started working extensively in Rust, using it with WASM as well for browser-based tooling. [Bert Temme](https://github.com/bertt) also added a [DotNet library](https://github.com/bertt/geoparquet). For Python users who are working in row-based paradigms, there is also support in [Fiona](https://pypi.org/project/Fiona/), which is great to see. And there’s a [GeoParquet.jl](https://github.com/JuliaGeo/GeoParquet.jl) for those working in Julia.

{{< img src="images/20231003-airports.png" alt="chart showing airports in GeoParquet" caption="" >}}

And the most recent library to support GeoParquet is a pure javascript one in [loaders.gl](https://loaders.gl/docs/modules/parquet/api-reference/parquet-loader), thanks to [Ib Green](https://github.com/ibgreen). It will likely not support the full Parquet spec as well as using something like GPQ in WASM, since there is not a complete Javascript Parquet library. But it will be the most portable and easy to distribute option, so is a great addition.

The one library I’m now still hoping for is a Java one. I’m hoping someone in the GeoTools & GeoServer community takes up the call and writes a plugin, as that one shouldn’t be too difficult. And of course, we’d love libraries in every single language, so if you have a new favorite language and want what is likely a fairly straightforward programming project that will likely see some widespread open source use, then go for it! There are pretty good Parquet readers in many languages, and GeoParquet is a pretty minimal spec.

### The Tools
This is a much wider category, and I’m sure I’ll miss some. I’m loosely defining it as something a user interacts with directly, instead of just using a programming language (yes, an imperfect definition, but if you want to define it you can write your own blog post ;) ).

### Command-line Tools
I count command-line interfaces as tools, which means I’ll need to repeat two of the libraries above:

- **OGR/GDAL**— is obviously the king of the geospatial command-lines, and having GeoParquet support means that any master of its command-line, especially ogr2ogr, can easily get any file into and out of GeoParquet.
- **GPQ**—has a great command-line interface enabling conversion from GeoJSON and [‘compatible’ Parquet](https://github.com/opengeospatial/geoparquet/blob/22503a5710779f6d160ef7cf4ac55a76ccedef32/format-specs/compatible-parquet.md) to GeoParquet. It’s also got one of the easiest validators to work with, providing a full accounting of each of the checks:

{{< img src="images/20231003-validator.png" alt="GeoParquet validation" caption="" >}}

It’s super easy [to install](https://github.com/planetlabs/gpq#installation) on any machine, as Go has a really great distribution story, and is the main tool I use to do validation and when I’m working with Parquet data that’s not GeoParquet. The most recent release also does a really nice job description of your GeoParquet:

{{< img src="images/20231003-installgo.png" alt="description of GeoParquet" caption="" >}}
