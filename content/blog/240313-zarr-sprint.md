+++
date = "2024-03-13T01:00:00-01:00"
title = "Zarr Sprint Recap"
tags = [ ""
]
summary = "A summary of our Zarr sprint held at the LEAP NSF Science and Technology Center at Columbia University in New York City in February 2024."
author = "Michelle Roby"
author_url = "https://beta.source.coop/michelle"
author_title = "Radiant Earth Developer Advocate"
+++

{{< img src="images/20240313-zarr.jpg" alt="Zarr Logo">}}

On February 7th and 8th, in collaboration with [Earthmover](https://earthmover.io), we held a Zarr sprint at the [LEAP](https://leap.columbia.edu) NSF Science and Technology Center at Columbia University in New York City. A wide array of contributors from government, academia, and industry came to the sprint, including people from [NASA](https://www.nasa.gov), [CarbonPlan](https://carbonplan.org), [Development Seed](https://developmentseed.org), [Earthmover](https://earthmover.io), [Upstream Tech](https://www.upstream.tech), [Columbia University](https://leap.columbia.edu), [Hydronos Labs](https://www.hydronoslabs.com), and [Fused](https://www.fused.io).

In this post, I give a very brief overview of each of the topic areas we discussed. More importantly, I link out to the open issues, pull requests, discussions, and meeting opportunities identified at the sprint for continued development. 

## Zarr Specification

The purpose of the sprint was to continue development of the 
[Zarr](https://zarr.readthedocs.io/en/stable/spec.html) specification. Zarr is a chunked, compressed, N-dimensional array format primarily designed for storing large numerical arrays efficiently. It is commonly used in scientific computing, geospatial, bioimaging, and data analysis contexts.

Enhancements to the Zarr specification that we discussed at the spring are described below.

### Chunk Manifest / Virtual Concatenation

In this breakout session, the group engaged in a long technical discussion about a way to define arrays in a Zarr store as concatenations of other arrays in the store. You can read a draft Zarr Enhancement Proposal ([ZEP](https://github.com/zarr-developers/zeps)) of the discussion [here](https://github.com/zarr-developers/zarr-specs/issues/288#issuecomment-1939265240). Shoutout to [Tom Nicholas](https://github.com/TomNicholas) for documenting this so well! 

### Zarr-Python

[Joe Hamman](https://github.com/jhamman) led a group focusing on enabling support for V3 in Zarr-Python. This was part of an ongoing effort working toward Zarr-Python version 3.0 ([roadmap](https://github.com/zarr-developers/zarr-python/blob/main/v3-roadmap-and-design.md)).

The focus of this group was on closing outstanding issues on the roadmap and testing the development branch in common geospatial applications. Zarr-Python has traditionally been the canonical implementation of Zarr, and it is therefore a current priority since this effort delivers immediate impact to the largest swath of users, including those that use Zarr through downstream libraries (e.g. Xarray, Dask, Anndata, etc.).

### Geospatial Multi-Scales/Pyramids

In the Zarr pyramids breakout group, [Thomas Maschler](https://github.com/thomas-maschler) and [Max Jones](https://github.com/maxrjones) discussed the motivations for following the [OGC TileMatrixSet 2.0](https://docs.ogc.org/is/17-083r4/17-083r4.html) specification within the GeoZarr specification, which will be shared as a new issue to supersede [GeoZarr Issue #30](https://github.com/zarr-developers/geozarr-spec/issues/30). They also discussed reading those TMS into [rio-tiler](https://github.com/cogeotiff/rio-tiler) using Xarray and started a refactor of ndpyramid to support the TMS specification.

### Alternate backend for reading remote Zarr stores

[Kyle Barron](https://kylebarron.dev) worked on a prototype for an alternate store for Zarr Python using new async Python bindings to Rust's object-store project. You can see a prototype of object-store-based store implementation at [zarr-python#1661](https://github.com/zarr-developers/zarr-python/pull/1661). 

### GeoZarr Specification 

Throughout the sprint, the GeoZarr focus group, led by [Brianna Pagán](https://www.briannapagan.com), worked on examining the interoperability of GeoZarr and different existing tooling and store support. You can see the table [here](https://github.com/zarr-developers/geozarr-spec/blob/main/geozarr-interop-table.md).

One of the biggest realizations was that ArcGIS has a lot of existing support for Zarr, which is really exciting news! For other tools, there is still work to be done, especially for GeoTIFF-like data being stored in Zarr, which translates to updates needed within the GeoZarr specification. For example, there are functionality issues tied to support or lack thereof for specific compression algorithms. The GeoZarr Steering Working Group is working on providing a list of supported compressions for commonly used tools. There is also work to be done on specifying the organizational structure of GeoZarr and understanding where requirements from CF diverge from the Zarr data model. For this, we are focusing efforts on involving folks with CF expertise to guide these conversations. 

If you are interested in helping out, please join the next bi-weekly GeoZarr meeting every other Wednesday at 11 EST. The next will be March 20th and you can find the invite on the Zarr calendar or join directly from [this link](https://meet.google.com/jth-rstn-fwb). Check out the notes from past meetings at the [hackmd](https://hackmd.io/@briannapagan/geozarr-spec-swg/edit).

### HTTP Extension

A final priority of the Zarr Sprint was to get efforts rolling on how to better visualize Zarr on the web. 

[Kevin Booth](https://github.com/kbgg) is the lead on this effort. Currently, he has added some sidecar files with links to reference parent, child, and root relationships within a Zarr store that would allow a client to be able traverse a Zarr store without needing an object storage interface with list capabilities. To demonstrate how this could work, [Xavier Nogueira](https://github.com/xaviernogueira) created [traverzarr](https://github.com/xaviernogueira/traverzarr) which allows to navigate a Zarr store as if it were in a file system. A more detailed blog post with updates on this work to come in the next week.

This work continues to be worked on after the sprint. In collaboration with the Zarr community, the Cloud-Native Geospatial Foundation has started holding bi-weekly meetings to hack on this work. The next will be held at 12 EST on March 14th. If you would like to be involved in this, email hello@cloudnativegeo.org to be added to the meeting invite, or find the meeting link at the Zarr calendar [here](https://zarr.dev/community-calls/).

---

It was great to get a group of people together to spend some dedicated time on Zarr, and plenty of work remains. Please help keep the momentum of these efforts going by responding to any GitHub Pull Requests, Issues, or Discussions that you have opinions on and joining any of [the established Zarr meetings](https://zarr.dev/community-calls/) that are of interest to you.