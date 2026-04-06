---
date: "2026-04-01T00:00:00-06:00"
slug: geo-embeddings-sprint-march-2026
title: "Geo-Embeddings Sprint: Advancing Standards for Earth Observation Embeddings"
tags: []
summary: "CNG, Planet, and Clark University co-hosted the Geo-Embeddings Sprint in Worcester to define patterns and best practices for storing, cataloging, and accessing EO embeddings—and launched geoembeddings.org as a living resource for the community."
author: "[Eli Simonson](https://www.linkedin.com/in/eli-simonson/) and [Michelle Roby](https://www.linkedin.com/in/the-michelle-roby/)"
---

On March 10–11, CNG, Planet, and Clark University co-hosted the Geo-Embeddings Sprint in Worcester, Massachusetts. The goal of the sprint was to define emerging patterns and best practices for storing, cataloging, and accessing Earth observation (EO) embeddings, with the intention of sharing findings with the EO community for testing, feedback, and adoption.

Participants from organizations including The Allen Institute for AI (Ai2), Esri, Earth Genome, Development Seed, Element 84, LGND, Wherobots, the University of Cambridge, and the University of Münster discussed what model providers could do to benefit downstream users and how to take advantage of existing cloud-native geospatial formats and best practices.

{{< img src="images/20260310-geo-embeddings-sprint-participants.png" alt="Participants at the Geo-Embeddings Sprint, Clark University, Worcester, Massachusetts, March 2026" >}}

## Framing the problem around EO embeddings

EO embeddings, compressed feature representations derived from satellite imagery, are emerging as a powerful new data source. By summarizing large volumes of imagery into dense vectors, from multiple satellites and sensors, embeddings enable enhanced workflows for context-based similarity search, large-scale change detection, and pattern recognition that were not previously possible.

While EO embeddings offer serious potential for the future of geospatial analytics, adoption has been limited by the absence of shared conventions for:

* Data layout and storage formats
* Metadata and provenance
* Query and retrieval patterns

Current implementations vary widely, making it difficult to build interoperable tooling or compare embedding products.

## Current use of EO embeddings

To kick off the event, each participant gave a short presentation on how they or their organization is using EO embeddings in practice. These examples highlight a shift from experimental workflows toward more integrated, production-oriented pipelines.

Several teams are building end-to-end systems that generate embeddings directly from satellite imagery and expose them for downstream use. Tools like RasterFlow, developed by Wherobots, support large-scale embedding generation as part of inference pipelines, working with Zarr and COG imagery and PyTorch-based models. Models such as Clay (developed by the founders of LGND) and OlmoEarth (Ai2) are used to produce patch- and scene-level embeddings from multi-modal inputs. In some cases, these outputs are further aggregated into temporal composites. For example, LGND generates monthly Sentinel-2 embedding products to reduce scene boundary artifacts and support time-series analysis.

Embeddings are increasingly being treated as a reusable data layer. Organizations are publishing precomputed embedding datasets, such as Asterisk Labs’ MajorTOM and Earth Genome pipelines, allowing users to query and analyze representations without rerunning models. At the same time, some workflows prioritize on-demand generation (e.g., Ai2), particularly where flexibility in model selection, spatial resolution, or temporal context is required.

Across implementations, there is a clear trend toward operationalizing embeddings as part of larger geospatial systems, linking model inference, storage, and query layers into cohesive workflows that can scale across datasets and use cases.

### Storage and data models

A central theme of the sprint was the distinction between embedding types and their corresponding storage patterns. Participants aligned on [Zarr](https://zarr.dev/) for regularly gridded, pixel-level embeddings, where data are naturally represented as multi-dimensional arrays (e.g., (time, y, x, embedding_dim)) and benefit from chunking and parallel access. [GeoParquet](https://geoparquet.org/) emerged as the preferred format for non-regularly gridded patch- or feature-level embeddings, where vectors are associated with geometries and can be indexed for spatial filtering and vector search.

There was a clear preference for collection-oriented formats (e.g., [Zarr stores](https://book.zarrs.dev/stores.html), [Parquet partitions](https://github.com/opengeospatial/geoparquet/blob/main/format-specs/distributing-geoparquet.md)) over file-based approaches like COGs, particularly at scale. These formats are designed for ease of access at scale through efficient partition pruning with Parquet headers and row group metadata, or Zarr’s self-describing JSON metadata. Open questions remain around [quantization and compression trade-offs](https://geospatialml.com/posts/compressing-earth-embeddings/), representing multi-scale embeddings, and supporting hybrid queries that combine spatial and vector search.

### Cataloging and metadata

Participants emphasized that metadata is essential for making embeddings usable and interoperable. Because embeddings are often treated as opaque representations, documenting [provenance](https://arxiv.org/html/2506.08597v1), including input data, models, and processing steps, is critical for trust and reproducibility.

Key challenges include standardizing how spatial, temporal, and spectral context are described, and how embeddings are linked back to source imagery and models. While several approaches are emerging, an open question remains around how to balance consistency with flexibility across diverse use cases.

## Key outcomes from the sprint

A primary outcome of the Geo-Embeddings Sprint is the launch of the website [geoembeddings.org](https://geoembeddings.org/) for education around all things EO embeddings.

This website serves as a living resource for the community, capturing early agreements, open questions, and evolving conventions around embedding storage, metadata, and access. It is designed to complement ongoing standardization efforts that can be tested and refined across systems and real-world use cases.

Initial contributions include a set of [best practices](https://geoembeddings.org/bestpractices.html) for storing and sharing embeddings using cloud-native geospatial formats, formalizing many of the patterns discussed during the sprint into implementable guidance. The repository also introduces structured templates for [dataset card](https://geoembeddings.org/data-card.html) and [model card](https://geoembeddings.org/model-card.html) documentation, along with a shared [glossary](https://geoembeddings.org/glossary.html) to support consistent terminology across projects.

## Next Steps

The Geo-Embeddings Sprint is the first in a series of collaborative efforts aimed at developing and validating community-driven standards for EO embeddings.

In the coming months, participants and the broader community will test the proposed best practices and specifications across existing datasets and workflows. The hope is that users can test out the proposed guidelines created during this sprint and provide feedback. This will allow for improvements and iterations on the suggestions laid out by this group.

We will be hosting monthly Geo-Embeddings meetings, providing a forum to share progress and iterate on proposals. The first meeting will be held on Thursday, April 9, at 11 a.m. PT | 2 p.m. ET | 8 p.m. CEST and on the first Thursday of the month thereafter. To get an invitation to the monthly meetings, request to join the Geo-embeddings Google Group at [geo-embeddings-community@cloudnativegeo.org](https://groups.google.com/a/cloudnativegeo.org/g/geo-embeddings-community). Please provide a short write-up of your reasoning for wanting to join these meetings.

To close out this effort, a final sprint will be held at IBM’s office in Zürich in late October. This meeting will be a space to build on the work done during this sprint and further implement the feedback collected by the broader EO embeddings community. Additionally, this second meeting will be a time to establish performance benchmarks and develop a global adoption and support roadmap.

## Acknowledgments

This sprint was made possible through support from the Navigation Fund Open Science program. We thank Radiant Earth, Clark University’s Center for Geospatial Analytics, Planet, and all participating organizations and individuals for their contributions.
