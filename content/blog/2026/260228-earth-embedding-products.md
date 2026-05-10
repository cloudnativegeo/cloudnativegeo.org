---
date: "2026-02-28T00:00:00-06:00"
title: "The Technical Debt of Earth Embedding Products"
tags: []
summary: "Every geospatial foundation model team solves the hard problem — training on petabytes of imagery. Nobody solves the easy one: letting other people use the output."
author: "[Isaac Corley](https://isaac.earth)"
author_title: "Senior Machine Learning Engineer, Wherobots"
---

Every geospatial foundation model team solves the hard problem — training on petabytes of imagery. Nobody solves the easy one: letting other people use the output.

Late last year our team spent three days debugging why AlphaEarth embeddings loaded upside-down and how to best handle it. The fix required patches to [GDAL](https://github.com/OSGeo/gdal/issues/13416), [Rasterio](https://github.com/rasterio/rasterio/issues/3094), and [TorchGeo](https://github.com/torchgeo/torchgeo/pull/3249). These aren't independent: TorchGeo depends on Rasterio depends on GDAL. All three need updates, all three need version pins, and now your users can't run older environments. One flipped coordinate killed backwards compatibility across the stack.

It keeps happening. Every new Earth embedding product ships like a snowflake, and if you want to compare or stack them, you end up writing glue code for half a dozen geospatial libraries. Our [paper](https://arxiv.org/abs/2601.13134) formalizes this with a taxonomy and TorchGeo integration. This post is about what keeps breaking and why the ecosystem still needs some work.

Moving AlphaEarth's 465 TB out of [Earth Engine](https://earthengine.google.com/) cost tens of thousands of dollars in egress fees. [Taylor Geospatial Engine](https://tgengine.org/building-frictionless-geospatial-ai-making-alphaearth-foundations-embeddings-accessible/) and [Radiant Earth](https://radiant.earth/) paid that bill so the rest of us don't have to — shoutout [Jeff Albrecht](https://github.com/geospatial-jeff) for the heavy lifting. Where you host and how you format at inference time sets the bill for everyone downstream.

## Three layers, one tradeoff

In the paper we organize the ecosystem into three layers: data, tools, and value. The **data layer** is where most decisions get made. Patch embeddings are cheap and small but sacrifice spatial detail. Pixel embeddings preserve more, but storage and bandwidth get expensive fast. The **tools layer** is where you figure out if embeddings are any good: benchmarks, [intrinsic dimension analysis](https://arxiv.org/abs/2511.02101). The **value layer** is what you build on top: mapping, retrieval, time-series. Most teams jump to the value layer without spending enough time in the tools layer first.

<table style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr>
      <th style="text-align: center; padding: 0.5em 1em; border-bottom: 1px solid var(--color-text);"><strong>Data</strong></th>
      <th style="text-align: center; padding: 0.5em 1em; border-bottom: 1px solid var(--color-text); border-left: 1px solid var(--color-text);"><strong>Tools</strong></th>
      <th style="text-align: center; padding: 0.5em 1em; border-bottom: 1px solid var(--color-text); border-left: 1px solid var(--color-text);"><strong>Value</strong></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center; padding: 0.5em 1em;"><strong>Embeddings</strong></td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);"><strong>Analysis</strong></td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);"><strong>Applications</strong></td>
    </tr>
    <tr>
      <td style="text-align: center; padding: 0.5em 1em;">Location embeddings</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Benchmarks</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Mapping</td>
    </tr>
    <tr>
      <td style="text-align: center; padding: 0.5em 1em;">Patch embeddings</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Intrinsic dimension</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Retrieval</td>
    </tr>
    <tr>
      <td style="text-align: center; padding: 0.5em 1em;">Pixel embeddings</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Open challenges</td>
      <td style="text-align: center; padding: 0.5em 1em; border-left: 1px solid var(--color-text);">Time-series</td>
    </tr>
  </tbody>
</table>

## Everything ships, nothing plugs in

Embeddings are scattered across [Source Cooperative](https://source.coop/), [Hugging Face](https://huggingface.co/), Earth Engine, private servers, and one-off GitHub repos. Each has its own tile scheme, CRS assumptions, file layout, and storage format. The teams behind these products did the hard part: petabyte-scale processing, cloud cover filtering, reprojection, model inference, etc. The distribution layer is where it falls apart.

Here's what we hit integrating each product into TorchGeo:

- **[Clay](https://source.coop/clay/clay-model-v0-embeddings):** Non-standard tile naming; had to reverse-engineer the grid layout from file paths. v1.5 now ships [NAIP](https://source.coop/clay/clay-v1-5-naip-2) (CONUS, 2010–2021) and [Sentinel-2](https://source.coop/clay/clay-v1-5-sentinel2) (partial global, 2018–2024) embeddings at 1024 dims. NAIP patches are 256m (1m GSD) vs Sentinel-2 at 2.56km (10m GSD), so the storage math is very different.

- **[Major TOM](https://huggingface.co/Major-TOM):** Parquet. One of the first large-scale embedding products — a good early step, though the original models (DINOv2, SigLIP, SSL4EO) are now dated compared to modern geospatial foundation models. Using multiple models enabled direct comparison of embedding outputs across architectures. Uses the Major TOM grid rather than the more common MGRS grid, which requires reprojection to align with other datasets. Distributed on Hugging Face rather than a cloud-native geospatial catalog.

- **[Earth Index](https://source.coop/earthgenome/earthindexembeddings):** Clean GeoParquet. This is what all of them should look like. Also check out the [source imagery](https://source.coop/earthgenome/earthindeximagery).

- **[Copernicus-Embed](https://arxiv.org/abs/2503.11849):** 0.25° resolution is ~25km at mid-latitudes. Too coarse for most applications but potentially useful for climate-scale analysis — TBD. The [embeddings are available on HuggingFace](https://huggingface.co/datasets/torchgeo/copernicus_embed).

- **[Presto](https://arxiv.org/abs/2304.14065):** GeoTIFF but with implicit CRS assumptions that differ from the imagery it was derived from. Hard to replicate the inputs outside Earth Engine and avoid vendor lock-in. See the [embeddings on Hugging Face](https://huggingface.co/datasets/izvonkov/Togo_Presto_Embeddings).

- **[Tessera](https://arxiv.org/abs/2506.20380):** Hidden behind an [API](https://github.com/ucam-eo/geotessera) running on a university server. Returns raw numpy arrays, not geospatial data. No CRS, no bounds, no metadata. You get numbers and a prayer. Their team is quite responsive and open to collaborations though.

- **[AlphaEarth](https://arxiv.org/abs/2507.22291):** Originally locked inside Earth Engine/GCP. After migrating 465 TB to [Source Cooperative](https://source.coop/tge-labs/aef), we converted the [tile index](https://data.source.coop/tge-labs/aef/v1/annual/aef_index.parquet) to [STAC-GeoParquet](https://github.com/stac-utils/stac-geoparquet) for easy [visualization in the browser](https://developmentseed.org/stac-map/?href=https://data.source.coop/tge-labs/aef/v1/annual/aef_index_stac_geoparquet.parquet).

> Every team solves distribution independently. You pay the tax once per product per user.

## What loading *should* look like vs what it actually looks like

**AlphaEarth — tile index**
```python
import geopandas as gpd
# GeoParquet tile index — query by bbox, get paths to COGs
index = gpd.read_parquet("aef_index.parquet", bbox=aoi)
# Each row: geometry + asset path, CRS, bounds, time range included
paths = index["data"]
```

**Earth Index / Clay v1.5 — GeoParquet**
```python
import duckdb
# GeoParquet — geometry + embeddings in one file, CRS baked in
df = duckdb.read_parquet("earthindex.parquet").to_df()
embeddings = df["embedding"]
geometry = df["geometry"]
# Same pattern works for Clay v1.5 (columns: geometry, embeddings)
```

**Tessera (reality)**
```python
from geotessera import GeoTessera
gt = GeoTessera()  # University API, no CRS, no bounds
bbox = (-0.2, 51.4, 0.1, 51.6)  # (min_lon, min_lat, max_lon, max_lat)
tiles_to_fetch = gt.registry.load_blocks_for_region(bounds=bbox, year=2024)
embeddings = gt.fetch_embeddings(tiles_to_fetch)  # Returns raw numpy — no spatial reference
```

## What's actually out there right now

On paper it looks clean. In practice every row hides a different file format, grid, and distribution story. Any single product works fine on its own. Try to compare two and you start tripping over assumptions you didn't know were there.

| Product | Kind | Spatial | Dims | Dtype | License |
|---------|------|---------|------|-------|---------|
| Copernicus-Embed | Patch | 0.25° | 768 | float32 | CC-BY-4.0 |
| Clay v1 | Patch | 5.12 km | 768 | float32 | ODC-By-1.0 |
| Clay v1.5 (S2) | Patch | 2.56 km | 1024 | float32 | CC-BY-4.0 |
| Major TOM | Patch | ~3 km | 2048 | float32 | CC-BY-SA-4.0 |
| Earth Index | Patch | 320 m | 384 | float32 | CC-BY-4.0 |
| Clay v1.5 (NAIP) | Patch | 256 m | 1024 | float32 | CC-BY-4.0 |
| AlphaEarth | Pixel | 10 m | 64 | int8 | CC-BY-4.0 |
| Tessera | Pixel | 10 m | 128 | int8 | CC0-1.0 |
| Presto | Pixel | 10 m | 128 | uint16 | CC-BY-4.0 |

For a city-scale workflow, any of these will do. At global coverage the lack of shared standards is the actual bottleneck, not model quality.

## The part everyone underestimates: storage

Nobody does the storage math until it's too late. `embedding_dim × dtype × spatial_resolution` compounds fast. A city-scale analysis is fine. Continent-scale? Pixel embeddings explode. None of this shows up in model cards. This mirrors a well-known challenge with hyperspectral data — tools optimized for 3-band RGB imagery often break when faced with hundreds of bands, and embedding dimensions present the same scaling problem.

### Continent-scale storage + cost (Africa, 30M km²)

| Product | Storage | $/mo | Egress |
|---------|---------|------|--------|
| Copernicus-Embed | 147.5 MB | $0.00 | $0.01 |
| Clay v1 | 3.5 GB | $0.08 | $0.32 |
| Clay v1.5 (S2) | 18.8 GB | $0.43 | $2 |
| Major TOM | 27.3 GB | $0.63 | $2 |
| Earth Index | 450.0 GB | $10 | $41 |
| Clay v1.5 (NAIP) | 1.9 TB | $43 | $169 |
| AlphaEarth | 19.2 TB | $442 | $1.7k |
| Tessera | 38.4 TB | $883 | $3.5k |
| Presto | 76.8 TB | $1.8k | $6.9k |

Presto and Tessera at 10m resolution mean **300 billion embeddings** for Africa alone. That's 77 TB for Presto (uint16) and 38 TB for Tessera (int8). Patch products like Clay and Copernicus-Embed stay under 4 GB, but you pay for that with spatial detail. That's why so many "global" embeddings end up being theoretical rather than something you can actually download and use.

Cost estimates use [AWS S3 Standard](https://aws.amazon.com/s3/pricing/) first-tier pricing: $0.023/GB/month storage, $0.09/GB egress. Volume discounts apply at scale but are excluded for simplicity.

## Hard truths

- **Stop over-indexing on Sentinel-1/2.** The oceans, atmosphere, and hyperspectral exist. We can't keep claiming we model the Earth if the majority of Earth is out of scope.

- **Cloud-native formats are table stakes.** [GeoParquet](https://geoparquet.org/), [COG](https://www.cogeo.org/), [GeoZarr](https://github.com/zarr-developers/geozarr-spec). Pick one and commit. Bespoke formats are a tax on every downstream user and they compound across products. The choice between vector and raster formats depends on your embedding type: patch-level embeddings fit naturally in GeoParquet (geometry + embedding vector per row), while dense pixel-level embeddings belong in raster formats like COG or Zarr. Hybrid models like [OlmoEarth](https://allenai.org/olmoearth) can produce both pixel and patch embeddings at different patch sizes — patch embeddings are just lower-resolution pixel embeddings and can be stored as dense Zarr or COG just the same.

- **Dimensionality and precision matter.** Nearly every foundation model uses a [Vision Transformer](https://arxiv.org/abs/2010.11929), so your embedding width is dictated by the variant: ViT-B (768), ViT-L (1024), ViT-H (1280). At float32 that difference alone can 1.7x your storage bill — and nobody has systematically studied whether all those dimensions are even necessary. Tessera experimented with quantization-aware training, AEF constructed a controlled study and found that quantizing during inference to int8 resulted in no noticeable loss on downstream performance. But what about 4-bits or even binary? How does this affect downstream performance for benchmarks of varying resolution, spatial extent, temporal cadence? Does quantization filter the signal of anomalies or rare events seen in geospatial data? These are open questions, and we should start shipping quantized embeddings by default to investigate.

- **Compression is a separate lever.** Beyond lossy approaches like quantization (float32 to int8), lossless compressors like [pcodec](https://github.com/pcodec/pcodec) can yield 2–5x compression on floating-point arrays — compression strategy deserves its own deep dive, which we'll cover in a future post.

- **Benchmarks must ship with models.** Private benchmarks kill reproducibility. If I can't run your eval, your numbers don't exist.

- **Embeddings need provenance.** Uncertainty estimates, source imagery hashes, model versions. Not all Sentinel-2 is made equal: L2A, [quarterly cloudless mosaics](https://dataspace.copernicus.eu/news/2023-11-28-quarterly-cloudless-sentinel-2-mosaics-available-data-collections-and-copernicus), and different [processing baseline versions](https://sentinels.copernicus.eu/web/sentinel/-/copernicus-sentinel-2-major-products-upgrade-upcoming) all shift the reflectance distribution, which breaks the input normalization that most satellite ML models depend on. Without provenance you can't tell if a difference is real or an artifact.

- **Train on the messy Earth.** Clouds, haze, snow, shadow — that's just what Earth looks like. Most teams curate their pretraining scenes by heavily filtering by cloud cover, then act surprised when the model falls apart at inference-time over the Amazon. The kicker is these same models pretrain on Sentinel-1 SAR, which sees through clouds anyway. Pretrain on the full distribution.

- **Temporal embeddings are still undercooked.** AlphaEarth, Tessera, and Presto encode time, but most released embeddings are annual composites that wash out everything shorter than a year. A field that rotates from winter wheat to summer corn? Both crops get averaged into the same embedding. Phenology and flooding have the same problem. Until embeddings ship at native temporal resolution, sub-annual change detection stays mostly manual.

## What you can do

**If you're producing embeddings:**

- Use GeoParquet for patch embeddings, COG or Zarr for pixel embeddings
- Include CRS metadata in every file — not in the README, in the file
- Document your tile scheme and create a spatial index
- Ship a benchmark with your model — not a private leaderboard, a runnable eval
- Include provenance: source imagery hash, model version, inference date
- Test quantization — int8 can cut storage 4x with minimal downstream loss
- Budget for egress before choosing a host — make it boring

**If you're consuming embeddings:**

- Use the [TorchGeo loaders](https://torchgeo.readthedocs.io/) — we've already eaten the integration pain
- File issues when things break — maintainers can't fix what they don't know about
- Compare products on the same AOI before committing to one at scale

## Looking forward

**Want to help define these standards?** Cloud-Native Geo is hosting a [sprint to define best practices for Earth Observation vector embeddings](https://cloudnativegeo.org/blog/2026/01/announcing-sprints-to-define-best-practices-for-earth-observation-vector-embeddings/). If you care about making these products interoperable, get involved.

## Read the paper

Fang, H., Stewart, A. J., Corley, I., Zhu, X. X., & Azizpour, H. (2026). Earth Embeddings as Products: Taxonomy, Ecosystem, and Standardized Access. [arXiv:2601.13134](https://arxiv.org/abs/2601.13134).
