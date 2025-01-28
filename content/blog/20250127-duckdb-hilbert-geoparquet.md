---
title: "Using DuckDB’s Hilbert Function with GeoParquet"
date: 2025-01-27T01:00:38-04:00
summary: "DuckDB's functionality has continued to expand, and as of version 1.1 it reads and writes GeoParquet natively, as long as you have the spatial extension installed."
author: "[Chris Holmes](https://beta.source.coop/cholmes)"
author_title: "Product Architect, Planet" 
---

DuckDB continues to be my go to tool for geospatial processing, after I discovered it over a year ago. Since that time its functionality has continued to expand, and as of version 1.1 it reads and writes GeoParquet natively, as long as you have the spatial extension installed.

== > LOAD spatial;
> CREATE TABLE fields AS
>> (SELECT * from >'https://data.source.coop/kerner-lab/fields-of-the-world-cambodia/boundaries_cambodia_2021.parquet');
> COPY fields TO 'cambodia-fields.parquet';==

Be sure to always run ==LOAD spatial;== or the table won’t get a geometry column, it will just create blobs. If you see errors or your output data is just Parquet and not GeoParquet that’s likely the source of your problems. I often forget to add it at the beginning of my sessions — perhaps there is some nice way to configure DuckDB to always load it, but I don’t know it (yet).
