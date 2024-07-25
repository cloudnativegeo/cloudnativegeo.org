# How to make your field boundaries more useful

In May we discussed the [fiboa ecosystem](https://cloudnativegeo.org/blog/2024/05/fiboa-the-ecosystem/) and mentioned that there is a new converter tool, which can take non-fiboa datasets and help you turn it into fiboa datasets. Back then we had 5 very similar datasets converted. In the meantime, we’ve converted additional datasets and improved the converter tool. Today, we’d like to give an update on the status and show how easy it is for you to make your field boundaries more useful by converting and providing them in a “standardized” format.

Seven persons are currently working on creating more than 40 converters:

- ~20 converters are fully implemented and available via pip

- ~20 converters are currently in development and available in a draft version

How does it work that we can convert so many datasets so easily?

We have implemented the [fiboa Command Line Interface (CLI)](https://github.com/fiboa/cli), which is a program that offers various tools to work with field boundary data. One of them is a command to convert field boundary datasets from their original form into fiboa. As field boundary data usually looks very similar conceptually (a geometry plus additional properties), most of the steps that are needed to convert the datasets to a standardized format can be abstracted away.

This means that the converter just needs a couple of instructions that describe how the original data looks like and then it can do all other steps automatically.

...

Once this all is done, you can make the converter to everyone. Everyone with access to the data can convert to fiboa at any time, e.g. if the source data has been updated. This makes it very easy to work with massive amounts of field boundary data, even across providers, and work against a standardized interface without the need to manually pre-process the data heavily to be comparable.

Join us and make your datasets available in a standardized format now!
We are happy to help if you run into issues, just get in touch via [email](mailto:matthias@mohr.ws) or [GitHub issues or pull requests](https://github.com/fiboa/cli).