+++
date = "2023-10-23T08:57:55-07:00"
title = "Introducing the Cloud-Optimized Geospatial Formats Guide"
tags = [ ""
]
summary = "Announcing a new community-led guide to help you navigate the expanding universe of cloud-native geospatial technologies."
+++

TL;DR: We’re excited to introduce the [Cloud-Optimized Geospatial Formats Guide](https://guide.cloudnativegeo.org) to help you navigate the ever-expanding universe of cloud-native geospatial technologies. Many thanks to [NASA’s Interagency Advanced Concepts and Implementation Team (IMPACT)](https://impact.earthdata.nasa.gov) and [Development Seed](https://developmentseed.org) for their leadership in creating this guide and opening up to the community.

---

Last week, [NASA announced](https://www.earthdata.nasa.gov/news/laads-daac-data-in-earthdata-cloud?fbclid=IwAR3erSJcWYl4iNVQelc32ls4kYOgHb8YVCIznwjquUcFPEeYBYgYa-2J7uw_aem_Ae5gOJsCo3U8SsdMJ1Y8u-k_7mE8jmDaQ2-_6JhHHUoLCqHabvVEMDKwJNVhP9ohLQo&mibextid=Zxz2cZ) that NASA’s Level-1 and Atmosphere Archive and Distribution System Distributed Active Archive Center (LAADS DAAC) has moved all of its storage to the cloud. [According to a lead on the project](https://www.linkedin.com/posts/splongmore_all-historical-data-from-nasas-laads-daac-activity-7120799801541070848-dUgM/), this represents 5.7 petabytes of data across 73 million data files. What’s more, the project was completed almost a year ahead of schedule. This is just one anecdote of many that shows how quickly a *lot* of geospatial data is quickly moving to the cloud.

This rapid migration to the cloud has created a movement toward "cloud-native" geospatial applications that take advantage of the scalability and performance of cloud infrastructure. Fueling these applications are new cloud-optimized geospatial data formats that are scalable, accessible, and flexible enough to be used in a wide array of applications. 

To help you navigate the expanding universe of cloud-optimized geospatial data formats, we’re excited to introduce the [Cloud-Optimized Geospatial Formats Guide](https://guide.cloudnativegeo.org).

Led by [NASA’s Interagency Advanced Concepts and Implementation Team (IMPACT)](https://impact.earthdata.nasa.gov) and [Development Seed](https://developmentseed.org), the [Cloud-Native Geospatial Foundation](https://cloudnativegeo.org) is hosting this community-powered guide to give newcomers and experts a single place to learn about best practices for working with data in the cloud. This guide is [managed on GitHub](https://github.com/cloudnativegeo/cloud-optimized-geospatial-formats-guide) and [openly-licensed](https://github.com/cloudnativegeo/cloud-optimized-geospatial-formats-guide/blob/main/LICENSE). [We encourage community contributions](https://guide.cloudnativegeo.org/contributing.html) to keep it up-to-date and valuable for all. 

{{< img src="images/20231023-cogeo-formats-table.png" alt="A diagram showing a variety of cloud-optimized geospatial formats" caption="Cloud-Optimized Geospatial Formats." >}}

Here is what to expect in the guide:
- An overview of cloud-optimized data and why you should consider it.
- A glossary of terms to help demystify the language used when discussing cloud-optimized data and get us all on the same page.
- Primers for the most common cloud-optimized formats and some newer formats gaining traction. 
- Vector, raster, datacubes, and point cloud data formats are covered!
- Notebooks with examples that you can try yourself.
- Links to lots of other resources to further enhance your understanding.
- Coming soon: Advanced topics!

Advanced topics will explore visualizing various data types (e.g., Zarr, GeoParquet) in browsers and Jupyter notebooks, mastering HTTP range requests, assessing chunking and compression configurations, and benchmarking performance for different use cases, such as time series generation vs spatial aggregations. Join the conversation in the [discussion board](https://github.com/cloudnativegeo/cloud-optimized-geospatial-formats-guide/discussions) to connect with a community of like-minded individuals, share insights and seek help. 

A sincere thank you to our dedicated authors, [Aimee Barciauskas](https://github.com/abarciauskas-bgse), [Alex Mandel](https://github.com/wildintellect), [Kyle Barron](https://github.com/kylebarron), and [Zac Deziel](https://github.com/zacharyDez). Thank you also to contributors of the Overview Slides: [Vincent Sarago](https://github.com/vincentsarago), [Chris Holmes](https://beta.source.coop/cholmes/), [Patrick Quinn](https://github.com/bilts), [Matt Hanson](https://github.com/matthewhanson), and [Ryan Abernathey](https://github.com/rabernat). Their expertise and commitment have been instrumental in bringing the guide to life. 