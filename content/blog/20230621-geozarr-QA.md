+++
date = "2023-06-21T10:00:00-00:00"
title = "Exploring the Potential of GeoZarr for Storage and Analysis"
tags = [ ""
]
summary = "An Interview with Brianna Rita Pagán, Deputy Manager at NASA Goddard Earth Sciences."
+++

<!-- {{< img src="images/20230621-brianna.jpeg" alt=" Brianna Rita Pagán" caption="Meet Dr. Brianna Rita Pagán." >}} -->

[Dr. Brianna Rita Pagán](https://www.briannapagan.com) is Deputy Manager at [NASA’s Goddard Earth Sciences](https://science.gsfc.nasa.gov/earth/) and adjunct Professor at Loyola Marymount University’s Seaver College of Science and Engineering. With a Ph.D. in Bioscience Engineering from Ghent University and numerous publications, Brianna has made significant contributions to push the advancement and accessibility of environmental solutions. 

In January 2023, Brianna volunteered to coordinate the community development process of [GeoZarr](https://github.com/zarr-developers/geozarr-spec), a project that aims to add geospatial capabilities to [Zarr](https://zarr.dev), which is a cloud-optimized file storage format for N-dimensional arrays. GeoZarr is a relatively new effort, but has quickly been adopted by the geospatial community. In this interview, we dive deeper into the intricacies of GeoZarr. We explore its origins, the advantages it offers, and the challenges of its implementation. 

### Let’s start with the basics. Could you explain the main purpose of Zarr in a nutshell? 

Zarr is a community project to develop software and specifications to support n-dimensional arrays which can be chunked and compressed for faster access. The arrays can be stored in memory, on disk, inside a zip file or in the cloud. 

Zarr addresses issues like what happens when your input or output data arrays are too large to fit in main memory. Zarr can also reduce bottlenecks encountered when you have limited I/O bandwidth. For use cases where computations can be run in parallel, a zarr divides the dataset into meaningful chunks. These chunks can be compressed, which increases effective I/O bandwidth and overall speeds up the entire computation processes. 

### What’s the historical background of Zarr? How did the idea for Zarr come about and what motivated its development?

Over the past few years there has been a total explosion of data across any field you can imagine. This exponential growth requires new tools to be able to effectively use data. Zarr was created by Alistair Miles to address this challenge of ever-growing n-dimensional arrays with a ‘hackable’ data format. The initial implementation was made in python back in 2015. Zarr is now a community model currently organized by Sanket Verma and is available in many different languages. 

The history of GeoZarr dates back to January 2022, when a young company called Consteller was contracted by ESA to provide a cloud native database. Originally the effort focused on using cloud-optimized geotiffs (COGs), but the datasets were coming in with additional dimensions beyond latitude and longitude including time, light spectrums, etc. Zarr appeared to fulfill the capabilities for speed that were needed, but common geospatial libraries like xarray, rasterio, and gdal required additional geospatial metadata. Christophe Noel created the first draft of the GeoZarr specification, based on x-arrray conventions. At the time he adopted CF conventions with an interest in extending the specification to include geotiff capabilities. In January 2023, [Ryan Abernathey](https://www.linkedin.com/in/ryan-abernathey-32a70652/) connected Christophe and me to continue pursuing this work. 

### Why Zarr? What makes it unique compared to other data storage formats and solutions? 

Zarr is unique because it is an implementation of a chunked storage library for data that supports parallel reads, parallel writes, and easily plugs into different storage systems like cloud object stores. 

There are other file formats that allow for storing multidimensional arrays, namely HDF5, which also allows for dividing arrays into regular compressed chunks in hierarchies. However, when scaling up there are clear limitations with HDF5. At the time of the creation of Zarr, there was no ability for thread-based parallelism with HDF5, it could not do parallel writes with compression, and there was no native cloud support.  


### As a Bioscience Engineer, you possess expertise in integrating engineering principles with environmental systems. How do you see the intersection of engineering and geospatial data, particularly in terms of leveraging technologies like Zarr for the storage and analysis of geospatial information? 

As a professor who teaches geospatial data analytics to undergraduate and graduate civil engineering students, I can attest to how the explosion of data has unintended consequences of actually limiting usability due to 1) increased demands on computational resources and 2) lack of centralized data distribution. The average laptop cannot handle the analysis of such large data. Cloud computing as well as cloud-optimized data formats are necessary. However, the costs and access to cloud computing are another barrier. The roles of [STAC](https://stacspec.org) and Zarr are also critical to improve searchability. In a perfect world, someone who wants rainfall data would have access to a data cube, which maps all rainfall datasets regardless of whether it’s distributed at NASA, NOAA, ECMWF, etc. It is truly a fascinating intersection to be at during a time when we can record an infinite amount of new data that will push the advancement of science and technology - but are still at the first steps of understanding how to manage the data and empower scientists and researchers. 

### Can you share some challenges or limitations that users should be aware of when using Zarr for their storage or computing needs?

There is *plenty* of work to do when it comes to using Zarr and landing on an approved GeoZarr specification. As with any new data format type, there are limitations as the convention and specifications are constantly evolving. For example, there is a clear need for pyramiding (multi-scaling support) for the Zarr convention. This will be a critical aspect for GeoZarr as a downstream specification. There are sketchings of a solution [see this example](https://github.com/carbonplan/ndpyramid) but nothing is finalized and we still require implementers and community input. For active archives like NASA, there are still technical questions to be addressed for best practices when using Zarr for datasets that are continually updated. 

### There have been many conversations about the intersection of Zarr’s data model and the Spatiotemporal Asset Catalog (STAC) metadata specification over the past few years. Notably, Ryan Abernathey believes that Zarr resembles [a data catalog more than a file format](https://discourse.pangeo.io/t/metadata-duplication-on-stac-zarr-collections/3193/2). Do you have opinions on how Zarr and STAC complement each other?

I agree with Ryan and others that Zarr and STAC are conceptually more aligned than Zarr and COG or any other cloud-optimized format. Even on the main Zarr website, you do not see terminology stating that Zarr is a data format, rather Zarr is a “community project to develop software and specifications to support n-dimensional arrays.” Just like STAC, Zarr provides a way to catalog and improve searchability. However, Zarr does take it one step further. 

### Are there any resources that you would recommend for someone who wants to learn more about Zarr and its usage?

Absolutely! The Zarr community is very well organized and every week either offers office hours or a community call: [https://zarr.dev/office-hours](https://zarr.dev/office-hours) 

If anyone is interested in following the current status of the GeoZarr specification, check out the [github repository](https://github.com/zarr-developers/geozarr-spec) and [our notes](https://hackmd.io/@briannapagan/geozarr-spec-swg).
