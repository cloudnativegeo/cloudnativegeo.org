---
date: "2026-03-03T00:00:00-06:00"
title: "Introducing geoparquet-io"
tags: []
summary: "An opinionated Python CLI tool for optimizing GeoParquet data"
author: "Chris Holmes and Nissim Lebovits"
---

We're releasing `geoparquet-io` (or, `gpio`), [an opinionated command-line tool](https://geoparquet.io/) for converting, validating, and optimizing GeoParquet files.

`gpio` is written in Python and uses DuckDB (with GDAL embedded for legacy format support), PyArrow, and `obstore` for fast operations on larger-than-memory datasets. By default, `gpio` enforces best practices: `bbox` columns, Hilbert ordering, ZSTD compression, and smart row group sizes.

### What does it do?

`gpio` offers a CLI and a [fluent](https://en.wikipedia.org/wiki/Fluent_interface) Python API to help you create, validate, and optimize GeoParquet files. The CLI is designed for composability; commands chain together with Unix pipes, produce structured output with `--json` flags, and are predictable enough for use with AI coding assistants. The Python API keeps data in memory as Arrow tables, avoiding file I/O entirely and integrating directly into existing workflows.

#### Convert with optimized defaults

With `gpio convert`, you can seamlessly convert from (and to) legacy formats like Shapefiles, GeoJSON, and GeoPackages:

```bash
# One command: converts, adds bbox, Hilbert-sorts, compresses
gpio convert buildings.shp buildings.parquet
```

By default, the resulting GeoParquet files are optimized for [best practices](https://geoparquet.io/concepts/best-practices/), including:

- `bbox` column with covering metadata
- Hilbert curve spatial ordering
- ZSTD compression
- Appropriate row group sizes
- Automatic partitioning (when appropriate)

These optimizations improve compression, I/O, and spatial query performance by 10–100x. Existing GeoParquet files can also be optimized in-place with `gpio check all --fix`.

#### Pipes and chains

One of `gpio`'s strengths is composability. On the CLI, commands chain together with Unix pipes using Arrow IPC streaming—no intermediate files:

```bash
# Extract Senegal from global admin boundaries, Hilbert-sort
gpio extract --bbox "-18,14,-11,18" \
  https://data.fieldmaps.io/edge-matched/humanitarian/intl/adm2_polygons.parquet | \
  gpio sort hilbert - senegal_adm2.parquet
```

```bash
# Chain enrichment steps together
gpio add bbox input.parquet | \
  gpio add h3 --resolution 9 - | \
  gpio sort hilbert - enriched.parquet
```

The Python API mirrors this with a fluent interface:

```python
import geoparquet_io as gpio

gpio.read('buildings.parquet') \
    .add_bbox() \
    .add_h3(resolution=9) \
    .sort_hilbert() \
    .write('s3://bucket/optimized.parquet')
```

#### Large files and cloud workflows

Large files can be automatically partitioned based on a target row count. Partitioning strategies include H3, KD-tree, quadkey, admin boundaries (via Overture and GAUL), A5, and S2, as well as partitioning by an arbitrary existing column.

DuckDB handles all transformations with streaming SQL execution—memory stays constant regardless of file size. Its spatial extension reads legacy formats via GDAL's `ST_Read`, and its httpfs extension handles remote file reads from S3, GCS, and Azure. PyArrow handles Parquet I/O and returns Arrow tables for seamless integration with pandas and Polars. For cloud writes, `obstore` enables streaming output to S3, GCS, and Azure.

```bash
# Convert shapefile → auto-partition by H3 → write directly to S3
gpio convert large_roads.shp | \
  gpio partition h3 - s3://bucket/roads/ --auto --hive --profile prod
```

#### Why not GDAL?

`gpio` uses GDAL under the hood—it's what makes all the format conversions work. The difference is focus: GDAL is a general-purpose toolkit, while `gpio` is opinionated about cloud-native GeoParquet with sensible defaults.

One example is cloud storage. Remote reads and writes in `gpio` just work—pass a URL and go:

```bash
# Just works - no /vsicurl prefix needed
gpio inspect https://data.fieldmaps.io/edge-matched/humanitarian/intl/adm2_polygons.parquet
```

| Feature | GDAL 3.9+ | gpio |
| --------------------- | ----------------------- | -------------------------------- |
| `bbox` column | Yes (default) | Yes |
| Spatial sorting | Optional, `bbox`-based | Hilbert curve (better clustering) |
| Sorting default | OFF | ON |
| Sorting overhead | Temp GeoPackage file | In-memory or streaming |
| Partitioning | No | H3, S2, A5, quadkey, KD-tree, admin |
| Validation | No | Spec compliance checking |
| Fix issues in-place | No | `--fix` flags |
| Read from S3/HTTP | `/vsis3/` or `/vsicurl/` prefix | Just use the URL |
| Write to S3 | Manual `/vsis3/` + env vars | Direct path via `obstore` |
| Credential handling | Manual configuration | Automatic (AWS, GCP, Azure) |

#### Additional features

- `bbox`-based subsetting of datasets for spatial filtering and extraction
- Service extraction from ArcGIS Feature Services and BigQuery tables → GeoParquet
- Easy inspection of metadata, row previews, and statistics
- PMTiles generation via the `gpio-pmtiles` plugin
- A [Claude Code skill](https://github.com/geoparquet/geoparquet-io/tree/main/skills/geoparquet) for AI-assisted spatial data workflows

`gpio` supports GeoParquet 1.1, 2.0, and native Parquet geometry/geography types. For the full docs and examples, see [geoparquet.io](https://geoparquet.io/).

### How can I help?

`gpio` is currently released in [v1.0-beta](https://pypi.org/project/geoparquet-io/). At this stage, we're looking for early users to help with stress-testing, bug reports, feature requests, and—of course—PRs. Check out the [open GitHub issues](https://github.com/geoparquet/geoparquet-io/issues) to see what's currently planned.