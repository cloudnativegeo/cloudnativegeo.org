---
title: "A deep dive into GeoParquet Downloader QGIS Plug-in"
date: 2025-02-01T01:00:38-04:00
summary: "An overview of the QGIS plug-in development and the motivations behind creating the plug-in."
author: "[Chris Holmes](https://www.linkedin.com/in/opencholmes)"
author_title: "Product Architect, Planet" 
---

Last month I released [my first QGIS plug-in](https://github.com/cholmes/qgis_plugin_gpq_downloader/), and promised I’d write an in-depth post about it. I’ll give an overview and dig into some of the motivations, and then I’ll put the details of my experience of coding with AI in its own follow up post.

{{< img src="images/20250201-geoparquet-downloader1.png" >}}

## Background
I’ve been a long time QGIS user, though am very far from an expert — I mostly open different files and visualize them. I’ve never been able to afford an Esri license, so it’s QGIS all the way for me. And I’ve always loved the plugin ecosystem: the fact that many people worldwide are adding all kinds of functionality so that anyone can customize it to their needs is just awesome, and a testament to the power of open source. There’s still things Esri can do better, but we’re now at the point where there’s a lot of things QGIS can do better.

I also recently have ‘become a coder’ again, thanks to the power of AI tools. I’ll dive into more of the experience in my next post, but it meant that I could tackle something like a new QGIS plugin as a (long) weekend project. I started it just to see if I could, and things kept working, so I kept pushing on.

## Motivations
One of my latest missions is to advance GeoParquet as a format to fulfill the promise of [cloud-native vector](https://cholmes.medium.com/an-overview-of-cloud-native-vector-c223845638e0) data, enabling organizations to get most all the functionality of a Web Features Service like [GeoServer](https://geoserver.org) by simply putting up their data as GeoParquet on a cloud bucket. I was so excited when Overture Maps embraced the format, but they also got a good bit of pushback for not having a ‘download’ button and using traditional data formats.

I was confident that if things evolved right it shouldn’t be hard to give traditional GIS users an even better experience of getting the data, since you can easily stream just what you need and transform it on the fly. A big shout out to Jake Wasserman and Overture for really stepping in to help push forward the evolution, proposing the key [bbox covering](https://github.com/opengeospatial/geoparquet/blob/v1.1.0/format-specs/geoparquet.md#covering) and upgrading Overture to fully implement it.

A few months ago it became possible to use [my favorite new geospatial tool](https://medium.com/radiant-earth-insights/duckdb-the-indispensable-geospatial-tool-you-didnt-know-you-were-missing-5fe11c5633e5), DuckDB (or a number of other tools), with any Overture data layer to select a spatial subset of the whole world and download just the area you cared about in tens of seconds and often faster.

{{< img src="images/20250201-geoparquet-downloader2.png" caption="Getting Overture data today">}}

Overture has great docs for using DuckDB, and they also built a nice command-line tool, but you still have to be tech-oriented and inclined to use a terminal. They did also build a nice [Explorer app](https://explore.overturemaps.org/#15/38.90678/-77.03649), that lets you download small amounts of data. But if you wanted more than a few megabytes worth of data to load up in QGIS there still weren’t great options for those who do want to learn to use a terminal and CLI tools.

So I decided to see how far the LLM coding tools had come and figure out if I’d be able to write a QGIS plugin. QGIS development had always intimidated me: I think I had one class in college that did desktop UI’s and I found it hard to grok. But my first attempt got something on my screen and within twenty minutes I had a reasonable kernel of functionality. I ended up able to get the vast majority of it working as I wanted to in a few days during the week of Thanksgiving — coding on the plane and sneaking in mini-sprints between family time.

So my goal was to make it as easy as possible for any QGIS user to download Overture, and indeed to not force GeoParquet on them: with the plugin you can easily request data as a GeoPackage. And I also wanted to make it easy to download any GeoParquet data, so that the tool isn’t just for Overture data, but enables anyone distributing their data as GeoParquet to easily enable QGIS users to get their data.

## Plugin Overview
This animated gif probably gives the quickest overview to understand what the plugin enables:

{{< img src="images/20250201-geoparquet-downloader3.gif" >}}

The idea is to make it simple to just download GeoParquet data into a local copy in QGIS. It currently just uses the bounds of the viewport, but I hope a future version can give more options to draw a geometry or use other QGIS layers ([contributors welcome!](https://github.com/cholmes/qgis_plugin_gpq_downloader/issues/10)).

Currently there are a few pre-set layers. All of Overture is obviously available, and it’s got a dedicated button to open its panel. And [Source Cooperative](https://source.coop) is easily the other largest single collection of GeoParquet files (and if you have open data you’d like to make available on Source then you can likely host it there for free — just reach out!). I still need to add more Source Cooperative files, indeed I hope to make a complete [fiboa](https://github.com/fiboa) & [Fields of The World](https://fieldsofthe.world/) section, as we’ve got a lot of data up there.

{{< img src="images/20250201-geoparquet-downloader4.png" >}}

And after the initial release I added a Hugging Face section, which for now is just the [Foursquare OS Places](https://huggingface.co/datasets/foursquare/fsq-os-places) dataset, but it seems like more will be added (I contemplated adding the various embeddings datasets but wasn’t sure of the practical use case of making it easier to download). And you can also just enter any custom URL to a GeoParquet online.

Right now you can download data as GeoParquet, DuckDB and GeoPackage. GeoPackage will always work, as all QGIS installations support it. GeoParquet should work on most more recent installations, though [OS/X is less straightforward](https://github.com/cholmes/qgis_plugin_gpq_downloader/wiki/Installing-GeoParquet-Support-in-QGIS) (But I am working with [opengis.ch](http://opengis.ch) to try to make this better!). DuckDB right now won’t load in QGIS, but I’m starting to collaborate with [QDuckDB](https://plugins.qgis.org/plugins/qduckdb) plugin team and I *think* I should be able to render the results of a DuckDB download if their plugin is installed.

{{< img src="images/20250201-geoparquet-downloader5.png" caption="The awesome QDuckDB plugin">}}

And that team also deserves a shout-out. Their plugin was the one I looked at the most for how to structure things, and they are working to solve a core issue that I need for the plugin to work well — install DuckDB. DuckDB is the core engine that powers the entire thing, as everything I did was just wrappers to all of its amazing functionality.

## Installing the plugin
If this seems like something that’s useful to you it should be pretty easy to install the plugin. Just open the plugin manager and search for ‘GeoParquet’.

{{< img src="images/20250201-geoparquet-downloader6.gif" >}}

I think the installation process is now pretty good. Matt Travis, the first outside contributor to the plugin, worked to get it to automatically install. I think it works most of the time, but I’m not 100% sure — it attempts to automatically use ‘pip’ to install DuckDB, but I’d guess that’s sometimes blocked. My hope is GDAL 3.11 [with ADBC support](https://github.com/OSGeo/gdal/pull/11459) will enable a more ‘native’ DuckDB experience in QGIS, and that we’ll be able to include it as a core dependency.

{{< img src="images/20250201-geoparquet-downloader7.png" caption="ADBC GDAL/OGR docs — coming in 3.11!">}}

## Future Features
It is on the list for the plugin to [add support for more formats](https://github.com/cholmes/qgis_plugin_gpq_downloader/issues) (which should be a [great first issue](https://github.com/cholmes/qgis_plugin_gpq_downloader/issues?q=is%3Aissue+state%3Aopen+label%3A%22good+first+issue%22) for any potential contributors) — FlatGeobuf is the top of my list, and File Geodatabase also sounds interesting. If there’s other formats desired just add them to the issue. I’m pretty opposed to adding Shapefile since it comes with [so many limitations](http://switchfromshapefile.org) that I think will get in the way of using Overture and other data, but if someone wants to make a PR and really needs it I’m sure I’d accept it.

I’ve got a number of ideas in the [issue tracker](https://github.com/cholmes/qgis_plugin_gpq_downloader/issues), but I’d love to hear from others what they’d like to see. I don’t see this being a huge project, and indeed I could see one route of ‘success’ being that this type of functionality is more incorporated into the QGIS core. It’s a bit of a different workflow, that I actually think would also be interesting with traditional geospatial servers (WFS, ArcGIS Feature Service, etc). Instead of having QGIS try to stream data on each screen change just have the user manually ‘check out’ the data that they want — download it and then display / use that local version.

The top future ideas that I’m thinking about are:

- User configurable data sources, instead of me maintaining the list and manually updating when new ones come. I could see making it so an organization can make their own ‘tab’ and even button that has a bunch of layers that are relevant to their users. And to make it easy for a user to add their own layers, instead of having to enter each manually.
- More download options beyond just the viewport, as mentioned above.
- Better integration with STAC, though that will need data providers to implement. But ideally you could point at a STAC catalog and get the list of Geoparquet layers to download.
- Ability to point at a GeoParquet file and see how well it implements ([in-progress) GeoParquet best practices](https://github.com/opengeospatial/geoparquet/pull/254). I started [a library to help do this](https://github.com/cholmes/geoparquet-tools), so hope to finish that and wrap it in this QGIS plugin (or maybe it will be a standalone plugin).

## What's Next 
I’d love more help on this project, and my hope is to make it an experiment of AI-enabled open source. Since I wrote 99% of it with AI coding tools I’m very happy to have all the contributions be similarly made, so if you’ve been wondering about how it all works and want a practical introduction that creates code for others to use then please take an issue!

I had thought I would also share more about my experience of using AI coding tools to create it, but since this post is already quite long I’ll break it up into its own. I’ve also got a number of insights into the state of public GeoParquet files and how we can improve the ecosystem of public data, but I’ll also save that for its own post. So stay tuned! I hope to publish both of those posts soon.
