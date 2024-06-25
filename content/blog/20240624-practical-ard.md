+++
date = "2024-06-25T00:13:12-07:00"
title = "Analysis-Ready Data in Practice from a Cloud-Native Perspective"
tags = [ ""
]
summary = "An overview of our current thinking on Analysis-Ready Data (ARD) based on work we've been doing with NASA, the Committee on Earth Observation Satellites (CEOS) Systems Engineering Office, and others over the past year."
author = "Matthias Mohr"
author_url = "https://mohr.ws/"
author_title = "[Radiant Earth](https://radiant.earth/) Technology Fellow"
+++

As Earth observation data becomes more abundant and diverse, the Earth Observation user community has spent considerable effort trying to find a common definition of "Analysis-Ready Data" (ARD). One of the most obvious reasons this is hard is that it relies on the assumption that we can predict what kind of analysis a user wants to perform. Certainly, someone using satellite imagery to analyze evapotranspiration is going to need something very different from someone trying to detect illegal mines.

Despite this, we believe there is some degree of preprocessing, metadata provision, and harmonization that will be useful for most users to move more quickly.

This blog post is an overview of our current thinking on ARD based on work we've been doing with NASA, the Committee on Earth Observation Satellites ([CEOS](https://ceos.org/)) Systems Engineering Office, and others over the past year.
 
## STAC

Some of the challenges of aligning around a definition of ARD has been solved by adoption of the [SpatioTemporal Asset Catalogs](https://stacspec.org/en) (STAC) metadata specification. In an ideal case, STAC metadata allows users to load data easily into a variety of configurations that might suit their needs &ndash; e.g. into a datacube.

STAC was designed to be flexible and has an intentionally small core that can be added to via extensions. Many STAC extensions have been developed, but there is no clear guidance on which extensions could be added to a STAC metadata catalog to create something that would be considered ARD. The best extensions to enable ARD may not even exist yet.

We need to create best practices that define which STAC extensions should be used (or developed) to signal that data should be considered analysis-ready. If we do this, we could use the concept of a STAC "profile" to define which combination of STAC extensions should be used and validated to create ARD data.

## CEOS-ARD

[CEOS-ARD](https://ceos.org/ard/) (formerly known as “CARD4L”) defines "product family specifications" for eight product types which are either categorized as "Optical" or "Radar". CEOS-ARD describes itself as follows:

> CEOS Analysis Ready Data (CEOS-ARD) are satellite data that have been processed to a minimum set of requirements and organized into a form that allows immediate analysis with a minimum of additional user effort and interoperability both through time and with other datasets.

This is a great resource to start from, especially with regards to the data pre-processing requirements. A lot of smart people from different space agencies have worked on it and concluded on a set of minimum requirements that are accompanied by additional optional requirements. The requirements are currently specified in (mostly tabular) PDF/Word documents, but they are in the process of migrating to a [GitHub and Markdown based process](https://github.com/ceos-org/ceos-ard). Implementors can go through the documents and check to see if they fulfill the requirements. For the synthetic aperture radar (SAR) product family specification, there’s additionally an XML metadata encoding available.

CEOS-ARD is a great foundation, and we have identified several areas where we believe it could be made even better.

### Right-sizing the number of CEOS-ARD metadata requirements

The SAR product family specifications include a large number of requirements that make it difficult to implement. SAR data is inherently complex, so I don’t expect we can change a lot, but there are likely some small tweaks we can propose to CEOS.

For [example](https://github.com/ceos-org/ceos-ard/issues/27), the SAR product family specification includes various file related metadata requirements that mostly apply to RAW data (e.g. header size and the byte order). Is RAW data really analysis-ready if such properties must be known? Usually software should handle that. Building on this, perhaps ARD formats should only be based on formats that are readable by GDAL because that is what most users use. In the geospatial world, GDAL is effectively a de-facto standard at this point, as most users use it directly or use software that uses it under the hood.

Ultimately, we should aim to make the ARD specification as complex as needed but as simple as possible. We also need to be careful to not have too many optional requirements and instead prioritize requirements that bring the most value to most users.

### Right-sizing the CEOS-ARD building blocks

CEOS-ARD is already somewhat split into building blocks, which are good enough for the purpose of CEOS-ARD. In general, however, they are too broadly scoped.

For example, one building block aims to cover all "product metadata" rather than discrete metadata about the capturing satellite or projection information. Ideally, CEOS-ARD would be defined in smaller blocks that the individual product family specifications can pick from, minimizing the development time of new product family specifications.

These building blocks could even match STAC extensions, but that might be difficult in some cases due to different scoping (STAC was primarily designed for search and discovery) and due to the fact that they are cleanly discretized (more on that below).

Another reason to split into smaller building blocks is that it allows smaller groups of experts to more easily work on individual building blocks. Limiting the scope ensures that the work is still manageable and you can get to a result in a reasonable amount of time. I believe we should aspire to follow the best practices of categorization / discretization as defined by [Peter Strobl (JRC)](https://it.linkedin.com/in/peter-strobl-79b7a191):

> - **assessable**: all characteristics used for distinguishing categories must be identified, and objective/measurable
> - **unambiguous**: categories mutually exclude each other
> - **gap free**: each item can be assigned to a specific category
> - **intrinsic**: assignment of an item to a category is independent of other, not previously agreed characteristics
> - **instantaneous**: assignment of an item to an category is independent of that of other items
> - **product family specifications**: different granularity in categorization is achieved by a hierarchy

Getting the categorization of the building blocks right will be very challenging, but I believe that once we have that settled it will be much easier to fill them with definitions for ARD. From there, it will be easier to evolve them into sets of building blocks that will be useful for specific types of data.

## STAC supports a user-centric and practical approach

Users currently seem to benefit a lot from STAC, as its standardization of metadata brings them one step closer to ARD already. CEOS-ARD has a separate XML-based metadata language, which is not ideal. I believe CEOS-ARD should be expressed in STAC, because it provides the metadata in a form that people already use and is supported by a vibrant software ecosystem.

ARD will only be adopted if it is supported by a software ecosystem that has users. Any approach to ARD should try to benefit from an existing ecosystem of software and learning resources, which STAC offers. Analysis-ready data and metadata is on it's own not analysis-ready. It always needs software that can actually benefit from the metadata and make the data available to users in a way that they can directly start in their comfort zone. That is usually their domain knowledge and a analysis environment such as Python, R, QGIS, or some other more or less popular application or programming language.

## Relation to OGC/ISO ARD

How does all this relate to the ongoing work in the OGC/ISO [ARD Standards Working Group](https://www.ogc.org/press-release/ogc-forms-new-analysis-ready-data-standards-working-group/)?

We believe that such a complex and large topic can’t be built top-down, it should be built bottom-up. It needs to evolve over time. Only once it has been iteratively improved, has implementations and some adoption, it should go through standardization.

ISO specifically doesn’t seem to be agile enough for this incremental approach, and I’m not sure about OGC. The emergence of STAC is an example of how a community-led de-facto best practice can emerge and then "graduate" into becoming a de-jure OGC standard.

We believe that the STAC-based approach for CEOS-ARD described in this post brings a lot to the table, and that any ISO/OGC work on ARD &ndash; however it continues in the next months &ndash; should be based on it. More specifically, we believe that ISO/OGC's approach to ARD should be a superset of CEOS-ARD. If (breaking) changes need to be proposed by the ISO/OGC work, they should be fed back into CEOS-ARD. If we end up with multiple more or less similar ARD specifications, everyone will loose.

## Conclusion

I hope this post provokes discussions among our community members who care about ARD. You may not agree with any of this, and it might not be the ultimate solution to ARD, but it may be a practical interim step while we figure out a “full-fledged” ISO ARD standard. Let us know what you think!

Drawing from what I've described here, the proposed next steps could be:

- Get into discussions about the categorization of the building blocks, including well-defined terminology
- Consult with CEOS whether STAC could be an official candidate for the metadata encoding for CEOS-ARD and maybe even a replacement for the existing XML encoding
- Continue working on the STAC CEOS-ARD extensions to be sure that the existing minimal requirements can all be expressed with STAC
- Modularize the CEOS-ARD specifications based on the building blocks
- Iterate on everything based on real-world examples and implementations
- Try to push for OGC/ISO ARD as a superset of CEOS-ARD
