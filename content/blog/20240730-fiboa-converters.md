# How to make your field boundaries more useful

In May we discussed the [fiboa ecosystem](https://cloudnativegeo.org/blog/2024/05/fiboa-the-ecosystem/) and mentioned that there is a new converter tool, which can take non-fiboa datasets and help you turn it into fiboa datasets. Back then we had 5 very similar datasets converted. In the meantime, we’ve converted additional datasets and improved the converter tool. Today, we’d like to give an update on the status and show how easy it is for you to make your field boundaries more useful by converting and providing them in a “standardized” format.

Seven persons are currently working on creating more than 40 converters:

- ~20 converters are fully implemented and [easily usable](https://pypi.org/project/fiboa-cli/)

- ~20 converters are currently in development and [available in a draft version](https://github.com/fiboa/cli/pulls)

How does it work that we can convert so many datasets so easily?

We have implemented the [fiboa Command Line Interface (CLI)](https://github.com/fiboa/cli), which is a program that offers various tools to work with field boundary data. One of them is a command to convert field boundary datasets from their original form into fiboa. As field boundary data usually looks very similar conceptually (a geometry plus additional properties), most of the steps that are needed to convert the datasets to a standardized format can be abstracted away.

This means that the converter just needs a couple of instructions that describe how the original data looks like and then it can do all other steps automatically. Some of these steps are:

- Read the data from the files in various formats such as Shapefiles, GeoPackages, GeoParquet files, GeoJSON, etc. The files can be loaded from disk or from the Internet. It can handle multiple source files, extract from ZIP files, etc. For example:
  
     ```python
     SOURCES = "https://sla.niedersachsen.de/mapbender_sla/download/FB_NDS.zip"
     ```
     
     This downloads the data from the given URL and loads the data from the files contained in the ZIP archive.
     
- Run filters to remove rows that shall not be in the final data, for example:

     ``````python
     COLUMN_FILTERS = {
         "boundary_type": lambda column: column == "agricultural_field")
     }
     ``````

     This keeps only the geometries for those boundaries that are of type `agricultural_field`.

- Add properties (i.e. columns) with additional information, for example:

     ``````python
     ADD_COLUMNS = {
       "determination_method": "auto-imagery"
     }
     ``````

     This adds the information that the boundaries were detected by a ML algorithm to the pre-defined property [`determination_method`](https://github.com/fiboa/specification/tree/main/core#determination-properties).

- Rename and/or remove properties, for example:
     ``````python
     COLUMNS = {
         "fid": "id",
         "geometry": "geometry",
         "area_sqm": "area"
     }
     ``````

     This is the list of property that you want to keep from the source data (here: `fid`, `geometry` and `area_ha`). The given property will be renamed to `id`, `geometry` and `area`, which are [pre-defined properties](https://github.com/fiboa/specification/tree/main/core) in fiboa. All other properties in the source data would get removed.

- Change the data values, for example:

     ``````python
     COLUMN_MIGRATIONS = {
         "area_sqm": lambda column: column / 10000
     }
     ``````

     This would convert the values for the property `area_sqm` from square meters to hectares (as the `area` property in fiboa requires the area to be in hectares).

- Create a file with additional metadata (i.e. a [STAC Collection](https://stacspec.org) with description, license, provider information, etc.).

- Write the data to the GeoParquet file.

Additionally, you should provide some general metadata about the dataset (e.g., title, description, provider, license) so that people know what they can expect. That's not really needed for the conversion though so I don't cover them here. The template also provides additional options and parameters that can be fine-tunes for your needs. You can have a look at the [full template](https://github.com/fiboa/cli/blob/main/fiboa_cli/datasets/template.py). It has documentation included and gives some examples. For even more examples check out [the filled templates for the existing converters](https://github.com/fiboa/cli/tree/main/fiboa_cli/datasets). There's also a tutorial that describes how to create a converter, either in [written form](https://github.com/fiboa/tutorials/tree/main/cli-convert) or as a [YouTube video](https://www.youtube.com/watch?v=-SUDzug29Cg&list=PLENrKR4uOfvXH-bDf1ornXgO6NdEL25ZS&index=4).

Once this is done, you can make the converter available by creating a [Pull Request](https://github.com/fiboa/cli/pulls) on GitHub and eventually it will be available to others. Everyone with access to the data can then convert to fiboa at any time, e.g. if the source data has been updated. It's really simple. To convert data you just can use the following command:

```bash
fiboa convert X -o result.parquet
```

Just replace X with any of the available converters. Use the command `fiboa converters` to list all available converters.

This makes it very easy to work with massive amounts of field boundary data, even across providers, and work against a standardized interface without the need to manually pre-process the data heavily to be comparable.

Join us and make your datasets available in a standardized format now!
We are happy to help if you run into issues, just get in touch via [email](mailto:matthias@mohr.ws) or [GitHub issues or pull requests](https://github.com/fiboa/cli).