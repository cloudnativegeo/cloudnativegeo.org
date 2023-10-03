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

One of the things I’m most proud of about GeoParquet 1.0.0 is how robust the ecosystem already is. For the 1.0.0 announcement I started to write up all the cool libraries and tools supporting GeoParquet, and the awesome data providers who are already providing interesting data in the spec. But I realized it would at least double the length of the blog post to do it justice, so I decided to save it for its own post.

### The libraries
The core of a great ecosystem is always the libraries, as most tools shouldn’t be writing their own special ways to talk to different formats — they should be able to leverage a well-optimized library so they can spend their time on other things. The first tool to support GeoParquet, before it was even called GeoParquet, was the great GeoPandas library. They added methods to read and write Parquet, and then Joris Van den Bossche and Dewey Dunnington started the process of standardizing the geospatial parquet format as part of GeoArrow as they explored cross-library reading and writing. Joris wrote the GeoPandas Parquet methods, and Dewey worked in R, working on the GeoArrow R library (there’s also another R library called sfarrow). Their initial work became the core of the GeoParquet spec, with a big thanks to Tom Augspurger for joining their community with the OGC-centered one where I started. We decided to use the OGC repo that I was working in for the GeoParquet spec, and to keep the GeoArrow spec repository focused on defining Geospatial interoperability in Arrow. Arrow and Parquet are intimately linked, and defining GeoParquet was much more straight forward, so we all agreed to focus on that first.
