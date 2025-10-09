---
date: 2025-10-09T08:00:00-00:00
title: "GeoParquet & Parquet geospatial types: A time of transition"
author: "[Chris Holmes](https://www.linkedin.com/in/opencholmes/)"
author_title: "Planet Fellow, Open & VP Product/Strategy/Partnerships & CNG Editorial Board Member"
summary: "This post makes the case for how the GeoParquet spec is preparing to phase out its own geometric format in favor of full Parquet compatibility."
---

Yesterday I read [Sylvain Lesage](https://rednegra.net/)’s post [Parquet with GEOMETRY type is not GeoParquet](https://rednegra.net/blog/20250925-parquet-with-geometry-type-is-not-geoparquet/) and started writing a reply for Linkedin but it ended up a bit too long to just be a comment, so I thought I’d just post it here as a blog. Overall it’s a great write-up and I appreciate that Sylvain took the time to share his understandings, and that he’s been diving deep to be able to support the geospatial + Parquet ecosystem. And most all of it is right on, but I wanted to provide some more context, and one tweak.

The only thing that I think is ‘off’ in the post is the timeline that says GeoParquet 1.1 was ‘published three months after the introduction of `GEOMETRY` and `GEOGRAPHY` in Parquet’. GeoParquet 1.1 was June 19th of 2024, while the geospatial types landed in Parquet core in March of 2025.

{{< img src="images/251008-geoparquet-types1.webp">}}

The original [PARQUET-2471](https://github.com/apache/parquet-format/pull/240) discussion started about 1 month before the 1.1.0 release. And the main topic for the core GeoParquet group members after the 1.1.0 release was to help ensure that Parquet and Iceberg geospatial types would be compatible and work well for the geospatial world. The core GeoParquet people were all quite happy to see this — our goal was always to bring Geo to Parquet, and having it as a core type is really the end state we were working towards.

Most of the work of the GeoParquet community after 1.1.0 manifested as a focus on the [Iceberg spec](https://medium.com/data-engineering-with-dremio/introducing-apache-iceberg-1-9-0-native-geospatial-support-enhanced-row-lineage-and-more-dead8950d391), as there were many overlaps between the core Iceberg and Parquet communities and they chose to first figure out Iceberg. I’d say that the desire to get geospatial support into Iceberg ended up being the main driver for geospatial support in Parquet, because Iceberg wanted to be able to rely on ‘vanilla’ Parquet. So they really drove the changes, and made sure that the two specs were quite compatible.

Generally the GeoParquet group members were a bit more ‘behind the scenes’, trying to help educate the core Parquet and Iceberg teams and ensure that there’d be a good path forward from GeoParquet. Since the release many of the core Parquet and Iceberg geospatial implementations have been driven by people in the GeoParquet community, specifically the great team at [Wherobots](https://wherobots.com).

We do have a rough plan for bringing GeoParquet and Parquet closer together, shared at a high level in [GeoParquet 2.0: Going Native](https://cloudnativegeo.org/blog/2025/02/geoparquet-2.0-going-native). The latest thinking is that we’d do a GeoParquet 2.0, that would just have one geometry type — the Parquet one. We’d drop support for the Arrow geometry type, as having a native geo parquet geometry achieves one of the main goals behind the arrow geometry, which was native stats and not needing the bbox column. There are some small size advantages of GeoArrow relative to WKB, but it doesn’t seem worth having a whole other type. And GeoArrow has a great future, but there’s no compelling reason to try to get it into Parquet.

So the idea behind GeoParquet 2.0 is to help transition the GeoParquet implementations to just read and write Parquet. We’ll continue to write out the geo key metadata, so that implementations can read it, but as readers become able to just read native Parquet then many will likely just skip the geo metadata. We’ll also take bbox out of the spec, since it’s main purpose was to provide stats to drive optimized spatial queries, and that’s not needed since Parquet will provide stats on geo types. I hope that we’ll also be able to provide a list of libraries / tools that implement the specs so it’ll be easy to tell the status and we can all encourage people to upgrade.

There is one interesting metadata field that I don’t think will ever make sense to be in Parquet, but that the geo world does make extensive use of, and that’s the primary column. There’s no such concept in Parquet, but it’s used by many geospatial tools to determine which geometry column to render when there is more than one geometry. So I could see a world where the geo metadata of geoparquet sticks around for that purpose.

Unfortunately we’ve been quite slow to actually get a spec out the door. I’ve tended to be the one to drive the actual editing of the spec, and my summer was crazy busy trying to pull off a move to the Netherlands on top of vacations to see family that were planned ahead of the move, while trying to stay above water with my day job. Jia [made an attempt](https://github.com/opengeospatial/geoparquet/issues/274) to run with it, but he’s also got a ton on his plate. I’m hoping in the next few months things will calm down and I can get to it.

But overall [the post](https://rednegra.net/blog/20250925-parquet-with-geometry-type-is-not-geoparquet) got most everything right, and our hope is to be able to provide clearer guidance in a GeoParquet 2.0 spec so that they are completely compatible and eventually it can just Parquet. Note that GDAL/OGR does have the ability to read/write Parquet geo types in version 3.12, and our hope is that when we have GeoParquet 2.0 it’ll make sense to have it write those by default.

{{< img src="images/251008-geoparquet-types2.webp">}}

Hopefully 2026 will be the year where we really start to see major datasets use Parquet GEOMETRY and GEOGRAPHY types. I believe most all the core Parquet libraries now support it, so the next step is really driving the geospatial libraries to start to not only use it, but to also write it by default. And the hope is that a GeoParquet 2.0 will help make that clear, and eventually all libraries will support the Parquet way so that GeoParquet metadata won’t even be necessary.
