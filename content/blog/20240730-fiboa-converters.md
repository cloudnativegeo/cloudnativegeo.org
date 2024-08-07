# Make your field boundaries more useful with fiboa

In May we discussed [fiboa](https://cloudnativegeo.org/blog/2024/04/introducing-fiboa/) and the [fiboa ecosystem](https://cloudnativegeo.org/blog/2024/05/fiboa-the-ecosystem/) and mentioned that there is a new converter tool, which can take non-fiboa datasets and help you turn it into fiboa datasets. Back then we had 5 very similar datasets converted. In the meantime, we’ve converted additional datasets and improved the converter tool. Today, we’d like to give an update on the status and show how easy it is for you to make your field boundaries more useful by converting and providing them in a “standardized” format.

Seven people are currently working on creating more than 40 converters:

- ~20 converters are fully implemented and [easily usable](https://pypi.org/project/fiboa-cli/)
- ~20 converters are currently in development and [available in a draft version](https://github.com/fiboa/cli/pulls)

How does it work that we can convert so many datasets so easily?

We have implemented the [fiboa Command Line Interface (CLI)](https://github.com/fiboa/cli), which is a program that offers various tools to work with field boundary data. One of them is a command to convert field boundary datasets from their original form into fiboa. As field boundary data usually looks very similar conceptually (a geometry plus additional properties), most of the steps that are needed to convert the datasets to a standardized format can be abstracted away.

This means that the converter just needs a couple of instructions that describe the source data and then it can do all other steps automatically.
The code is in Python, but we provide a template that is documented and contains examples. It's pretty simple to fill and most people that have some programming experience should be able to make the necessary changes.
Let's look at the most important steps in the conversion process:

- Read the data from the files in various formats such as Shapefiles, GeoPackages, GeoParquet files, GeoJSON, etc. The files can be loaded from disk or from the Internet. It can handle multiple source files, extract from ZIP files, etc. For example:
  
     ```python
     SOURCES = "https://sla.niedersachsen.de/mapbender_sla/download/FB_NDS.zip"
     ```
     
     This downloads the data from the given URL and loads the data from the files contained in the ZIP archive.
     
- Run filters to remove rows that shall not be in the final data, for example:

     ```python
     COLUMN_FILTERS = {
         "boundary_type": lambda column: column == "agricultural_field"
     }
     ```

     This keeps only the geometries for those boundaries that are of type `agricultural_field`.

- Add properties (i.e. columns) with additional information, for example:

     ```python
     ADD_COLUMNS = {
         "determination_method": "auto-imagery"
     }
     ```

     This adds the information that the boundaries were detected by a ML algorithm to the predefined property [`determination_method`](https://github.com/fiboa/specification/tree/main/core#determination-properties).

- Rename and/or remove properties, for example:
  
     ```python
     COLUMNS = {
         "fid": "id",
         "geometry": "geometry",
         "area_sqm": "area",
         "custom_property": "custom_property"
     }
     ```

     This is the list of property that you want to keep from the source data (here: `fid`, `geometry` and `area_ha`). The given property will be renamed to `id`, `geometry` and `area`, which are [predefined properties](https://github.com/fiboa/specification/tree/main/core) in fiboa. All other properties in the source data would get removed.

- Add custom properties, for example:
  
     ```python
     MISSING_SCHEMAS = {
          "properties": {
               "custom_property": {
                    "type": "string",
                    "enum": ["A","B","C"]
               }
          }
     }
     ```
     
     This defines that your custom property that is not predefined in fiboa or an extension with the name `custom_property` is of type string and can be any of the uppercase letters A, B, C (or `null`).
     This is probably the most complex task as it requires to define a schema for every custom property that you want to provide in addition to the predefined properties in fiboa or its extensions.
     You can find more information about the schemas in the [fiboa Schema specification](https://github.com/fiboa/schema).

- Change the data values, for example:

     ```python
     COLUMN_MIGRATIONS = {
         "area_sqm": lambda column: column / 10000
     }
     ```

     This would convert the values for the property `area_sqm` from square meters to hectares (as the `area` property in fiboa requires the area to be in hectares).

- Create a file with additional metadata (i.e. a [STAC Collection](https://stacspec.org) with description, license, provider information, etc.). That just requires updating some variables, for example:

     ```python
     ID = "de"
     SHORT_NAME = "Germany"
     TITLE = "Field boundaries for Germany"
     LICENSE = "CC-BY-4.0"
     ...
     ```

- Finally, write the data to a GeoParquet file.

Additionally, you should provide some general metadata about the dataset (e.g., title, description, provider, license) so that people know what they can expect. That's not really needed for the conversion though so I don't cover them here. The template also provides additional options and parameters that can be fine-tunes for your needs. You can have a look at the [full template](https://github.com/fiboa/cli/blob/main/fiboa_cli/datasets/template.py). It has documentation included and gives some examples. For even more examples check out [the filled templates for the existing converters](https://github.com/fiboa/cli/tree/main/fiboa_cli/datasets). There's also a tutorial that describes how to create a converter, either in [written form](https://github.com/fiboa/tutorials/tree/main/cli-convert) or as a [YouTube video](https://www.youtube.com/watch?v=-SUDzug29Cg&list=PLENrKR4uOfvXH-bDf1ornXgO6NdEL25ZS&index=4).

Once this is done, you can make the converter available by creating a [Pull Request](https://github.com/fiboa/cli/pulls) on GitHub and eventually it will be available to others. Everyone with access to the data can then convert to fiboa at any time, e.g. if the source data has been updated. It's really simple. To convert data you just can use the following command:

```bash
fiboa convert X -o result.parquet
```

Just replace X with any of the available converters. Use the command `fiboa converters` to list all available converters.

The `result.parquet` file can then be loaded into any software that can read Parquet files, for example QGIS. It can also be loaded in many programming languages such as Python or R. Loading multiple fiboa-compliant datasets makes it much simpler to work across multiple datasets as many properties are already aligned, so it's analysis-ready and can be used very fast and efficiently.

This makes it very easy to work with massive amounts of field boundary data, even across providers, and work against a standardized interface without the need to manually preprocess the data heavily to be comparable. For more details see also the section "Why a farm field boundary data schema?" in our blog post "[Introduction to fiboa](https://cloudnativegeo.org/blog/2024/04/introducing-fiboa/)".

Join us and make your datasets available in a standardized format now!
We are happy to help if you run into issues, just get in touch via [email](mailto:matthias@mohr.ws) or [GitHub issues or pull requests](https://github.com/fiboa/cli).
