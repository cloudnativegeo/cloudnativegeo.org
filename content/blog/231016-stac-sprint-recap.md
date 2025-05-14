+++
date = "2023-10-16T05:11:16-07:00"
title = "2023 STAC Sprint Recap"
tags = [ ""
]
summary = "What all happened during the STAC Sprint in Philadelphia."
author = "Michelle Roby"
author_url = "https://twitter.com/Michelle__Roby"
author_title = "Radiant Earth Developer Advocate"
+++

At the end of September, the Spatio-Temporal Asset Catalog (STAC) community members gathered together in Philadelphia (and virtually) to improve STAC, grow the ecosystem of tools around STAC, and discuss other complementary cloud-native geospatial projects. This was the 8th STAC Sprint and the first in-person sprint since 2019. After three days of effort, we made some great strides across the board.

{{< img src="images/20231016-welcome.png" alt="image showing the 8th STAC sprint participants" caption="Everyone gathered the first morning of the sprint." >}}

Based on the attendees of the sprint and their areas of expertise, we split up into four breakout groups. These groups were:

- STAC Specification(s): STAC core specification (stac-spec), STAC API specification (stac-api-spec), and their extensions
- STAC Ecosystem (stac-utils)
- STAC-GeoParquet
- Outreach and Education

The following sections outline what each group accomplished during the three days of the sprint and the next steps for each topic.

## STAC Specifications

### stac-spec

A considerable benefit of the sprint was to get together in person and resolve some of the community's longstanding online STAC discussions. Going into the sprint, there were around 10 issues with the label “discussion needed” in the stac-spec GitHub issues. During the sprint, each of these issues was discussed and a solution was determined. You can see the issues that will be completed as a part of the stac-spec 1.1.0 release in the [1.1 Milestone](https://github.com/radiantearth/stac-spec/milestone/30).

One of the most notable solutions made for the STAC Specification was the agreement on the [Bands Requests for Comments Discussion](https://github.com/radiantearth/stac-spec/discussions/1213). The agreed-upon solution is to create the new common metadata field `bands` to replace `eo:bands` and `raster:bands` as well as to add the following fields to the common metadata: `data_type`, `nodata`, `statistics`, and `unit`. You can see the pull request for this change at [radiantearth/stac-spec/pull/1254](https://github.com/radiantearth/stac-spec/pull/1254).

The STAC community will continue to work towards completing the issues in the 1.1 Milestone before releasing a v1.1.0. If you have any problems with the STAC Spec, it's now the time to make your voice heard. Submit issues to the respective STAC repository with an in-depth explanation of your problem: [stac-spec](https://github.com/radiantearth/stac-spec/issues) for STAC Specification issues and [stac-extensions](https://github.com/orgs/stac-extensions/repositories) for issues with STAC Extensions.

### stac-api-spec

As for the STAC API Specification, the group focused mainly on discussing several STAC API Extensions. Here are the discussed extensions and their new status:

- v1.0.0 released and updated to maturity level `Stable`:
    - [Fields Extension](https://github.com/stac-api-extensions/fields/releases/tag/v1.0.0)
    - [Sort Extension](https://github.com/stac-api-extensions/sort/releases/tag/v1.0.0)
    - [Query Extension](https://github.com/stac-api-extensions/query/releases/tag/v1.0.0)
- [Transaction Extension:](https://github.com/stac-api-extensions/transaction/releases/tag/v1.0.0-rc.3) v1.0.0-rc.3 release
    - waiting on OGC for OAFeat Part 4, possibly 2024
- [Filter Extension](https://github.com/stac-api-extensions/filter): Pull Request in for v1.0.0-rc.3 release
    - waiting on the CQL2 final from OGC, possibly Q4 2023

For the STAC API Specification, the goals moving forward are to get a release of recent updates to CQL2 released for the Filter extension, advocate for updating in implementations (including a new implementation in stac-serve), and continue to engage with OGC team on the future of CQL2 (including separating functionality into conformance classes that we expect implementers will be able to support).

## STAC Ecosystem

For the STAC ecosystem group, the majority of the work done was for [PySTAC](https://pystac.readthedocs.io/en/latest/index.html). A lot of work was done around extensions (notable work on the pointcloud extension for a v1.1) and continued development for v1.9.0.

Additionally, the group is in the process of developing a new, simpler interface for extensions and an extensions audit to ensure all versions are supported and tested.

As far as future efforts go, the stac-utils folks are following the bands Request for Comments (RFC) progress (decision discussed above) and have a work-in-progress Pull Request to add support to PySTAC when the RFC is accepted.

If you are interested in joining stac-utils virtual meetups, be sure to join the [STAC Community Google Group](https://groups.google.com/g/stac-community) to receive meeting invitations.

## STAC-GeoParquet

There is now a work-in-progress specification for STAC-GeoParquet which you can find at [stac-utils/stac-geoparquet/pull/28](https://github.com/stac-utils/stac-geoparquet/pull/28). The current goal is to turn this into a more official specification with a more diverse set of datasets that meet the specification requirements and evolve the stac-goeparquet library to be a bit more generic.

## Outreach and Education

I led a small group discussion around STAC outreach and education. The goal of this group was to identify how we can expand the STAC community to include a more diverse crowd.  

During this sprint, we focused on developing tutorials that target non-Python users. A huge shoutout to [Mike Mahoney](https://www.mm218.dev/) for developing three stellar tutorials that are now on the STAC website. These tutorials expand our STAC education into R – [Download data from a STAC API using R, rstac, and GDAL](https://stacspec.org/en/tutorials/1-download-data-using-r/) and [How to Query STAC APIs using rstac and CQL2](https://stacspec.org/en/tutorials/2-using-rstac-and-cql2-to-query-stac-api/) – and Command Line Interface with the [CLI data download tutorial](https://stacspec.org/en/tutorials/gdal_cli/). If you want to read more about cloud-native tools for non-Pyton users, check out Mike’s blog from a few weeks back: [“Cloud-Native Geospatial If You Don't Speak Snake”](https://cloudnativegeo.org/blog/2023/09/cloud-native-geospatial-if-you-dont-speak-snake/).

A few more tutorials from the sprint are still in progress and will be added to the STAC site tutorials section soon including an improved STAC Extensions tutorial by [Dimple Jain](https://www.linkedin.com/in/jaindimple/) and a tutorial on creating a STAC Catalog via the command line by [Mansi Shah](https://www.linkedin.com/in/mkshah605/).

For STAC documentation, a new STAC FAQ page was further developed (we first started building this at a STAC working session this fall) and will be added to the site in the coming months.

In addition to material creation, this group discussed important topics including barriers to entry into the STAC community and how to make STAC more accessible to newcomers. The Cloud-Native Geospatial Foundation will be holding a series of introduction webinars to STAC and cloud-native geospatial in the coming months. The first webinar is an introduction to STAC webinar for the Kenyan Space Agency (though it is free and open to the public) this Wednesday, October 18th at 9 a.m. EST. More information about this webinar can be found [here](https://www.eventbrite.com/e/webinar-series-geospatial-knowledge-sharing-for-professionals-in-kenya-tickets-718139393257).

## STAC Lightning Talks

In addition to collaborative work efforts, some attendees shared updates on the ways they are using STAC in their personal work. Each morning, we had a slot for 5-minute lightning talks or demos. It was great to see the variety of ways STAC is being harnessed in the work of the community. You can find the presentation slide deck [here](https://docs.google.com/presentation/d/1B18c5MI0-vmnbSOkIUjd-lMSLdwL0w7aa0rsqY3EQoE/edit?usp=sharing).

## Get Involved

If you want to know more about a given lightning talk or specifics about any of this work done at the sprint, join the [Cloud-Native Geospatial Foundation Slack organization](https://join.slack.com/t/cloudnativegeo/shared_invite/zt-259rmhcyo-bT6tabt3X_5_s6zUfxCwEg) and/or come to the STAC Community meetups (every other Monday at 11 a.m. EST) to meet many of the STAC Sprint participants and hear more about all the work they are doing related to STAC. You can join the STAC Community Google group to be added to the biweekly meeting and receive STAC-related emails: [groups.google.com/g/stac-community](https://groups.google.com/g/stac-community).



{{< img src="images/20231016-sponsors.jpg" alt="image showing the 8th STAC sprint sponsors" caption="" >}}