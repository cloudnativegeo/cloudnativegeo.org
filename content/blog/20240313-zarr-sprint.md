+++
date = "2024-03-13T01:00:00-01:00"
title = "Zarr Sprint Recap"
tags = [ ""
]
summary = "A summary of what we did at the 2024 Zarr Sprint."
author = "Michelle Roby"
author_url = "https://beta.source.coop/michelle"
author_title = "Developer Advocate @ Radiant Earth"
+++

{{< img src="images/20240313-zarr.jpg" alt="Zarr Logo">}}

A few weeks ago, a group of us met up in person, at LEAP in New York City, and virtually to hack on the Zarr specifications and ecosystem.

In this blog, I give a very brief overview of each of the topic areas. More importantly, I link out to the open issues, pull requests, discussions, and meeting opportunities for continued development. You can follow these links to both better understand each effort and also to contribute yourself. 

Please keep this work going by adding reviews and comments to online conversations and joining any relevant meetings/working sessions.

## Zarr Specification

[Zarr Specification](https://zarr.readthedocs.io/en/stable/spec.html) refers to the specification for a chunked, compressed, N-dimensional array format primarily designed for storing large numerical arrays efficiently. It is commonly used in scientific computing, geospatial, bioimaging, and data analysis contexts.

The specification defines how data should be organized within a Zarr store, including details on chunking, compression, metadata, and other attributes necessary to efficiently store and retrieve array data. This specification helps ensure interoperability between different software implementations that support the Zarr format.

The latest version of the specification is [V2](https://zarr.readthedocs.io/en/stable/spec/v2.html), but [Version 3](https://zarr-specs.readthedocs.io/en/latest/specs.html) is in the works.

### Chunk Manifest / Virtual Concatenation

In this breakout session, the group engaged in a long technical discussion about a way to define arrays in a Zarr store as concatenations of other arrays in the store. You can read a full ZEP-like description of the discussion [here](https://github.com/zarr-developers/zarr-specs/issues/288#issuecomment-1939265240). Shoutout to Tom Nicholas for documenting this so well! 

### Zarr-Python

Joe Hamman led a group focusing on enabling support for V3 in Zarr-Python. This was part of an ongoing effort working toward Zarr-Python version 3.0 ([roadmap](https://github.com/zarr-developers/zarr-python/blob/main/v3-roadmap-and-design.md)).
The focus of this group was on closing outstanding issues on the roadmap and testing the development branch in common geospatial applications. Zarr-Python has traditionally been the canonical implementation of Zarr, and it is therefore a current priority since this effort delivers immediate impact to the largest swath of users, including those that use Zarr through downstream libraries (e.g. Xarray, Dask, Anndata, etc.).

### Geospatial Multi-Scales/Pyramids

In the Zarr pyramids breakout group, Thomas Maschler and Max Jones discussed the motivations for following the [OGC TileMatrixSet 2.0](https://docs.ogc.org/is/17-083r4/17-083r4.html) specification within the GeoZarr specification, which will be shared as a new issue to supersede [GeoZarr Issue #30](https://github.com/zarr-developers/geozarr-spec/issues/30). They also discussed reading those TMS into [rio-tiler](https://github.com/cogeotiff/rio-tiler) using Xarray and started a refactor of ndpyramid to support the TMS specification.

### Alternate backend for reading remote Zarr stores

Kyle Barron worked on a prototype for an alternate store for Zarr Python using new async Python bindings to Rust's object-store project. You can see a prototype of object-store-based store implementation at [zarr-python#1661](https://github.com/zarr-developers/zarr-python/pull/1661). 

## GeoZarr Specification 

Throughout the sprint, the GeoZarr focus group worked on examining the interoperability of GeoZarr and different existing tooling and store support. You can see the table [here](https://github.com/zarr-developers/geozarr-spec/blob/main/geozarr-interop-table.md).

One of the biggest realizations was that ArcGIS has a lot of existing support for Zarr, which is really exciting news! For other tools, there is still work to be done, especially for GeoTIFF-like data being stored in Zarr, which translates to updates needed within the GeoZarr specification. For example, there are functionality issues tied to support or lack thereof for specific compression algorithms. The GeoZarr Steering Working Group is working on providing a list of supported compressions for commonly used tools. There is also work to be done on specifying the organizational structure of GeoZarr and understanding where requirements from CF diverge from the Zarr data model. For this, we are focusing efforts on involving folks with CF expertise to guide these conversations. 

If you are interested in helping out, please join the next bi-weekly GeoZarr meeting every other Wednesday at 11 EST. The next will be March 20th and you can find the invite on the Zarr calendar or join directly from [this link](https://meet.google.com/jth-rstn-fwb). Check out the notes from past meetings at the [hackmd](https://hackmd.io/@briannapagan/geozarr-spec-swg/edit).

## HTTP Extension

A final priority of the Zarr Sprint was to get efforts rolling on how to better visualize Zarr on the web. 

Kevin Booth is the lead on this effort. Currently, he has added some sidecar files with links to reference parent, child, and root relationships in the Zarr to be able to use something like [traverzarr](https://github.com/xaviernogueira/traverzarr), the first attempt at traversing a Zarr JSON as if it were a filesystem in developed by Xavier Nogueira during the sprint, to navigate a Zarr in a manner like the Spatio-Temporal Asset Catalog (STAC). A more detailed blog post with updates on this work to come in the next week.

This work continues to be worked on after the sprint. Cloud-Native Geospatial Foundation has started holding bi-weekly meetings to hack on this work. The next will be held at 12 EST on March 14th. If you would like to be involved in this, email hello@cloudnativegeo.org to be added to the meeting invite, or find the meeting link at the Zarr calendar [here](https://zarr.dev/community-calls/).

---

It was great to get a group of people together to spend some dedicated time on Zarr, and the work is nowhere near done. Please help keep the momentum of these efforts going by responding to any GitHub Pull Requests, Issues, or Discussions that you have opinions on and joining any of the established Zarr meetings that are of interest to you. Again, the Zarr calendar can be found [here](https://zarr.dev/community-calls/).