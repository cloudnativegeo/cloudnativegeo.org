+++
date = "2024-05-02T01:00:00-01:00"
title = "fiboa: The Ecosystem"
tags = [ ""
]
summary = "An introduction to the fiboa (Field Boundaries for Agriculture) ecosystem."
author = "Chris Holmes"
author_url = "https://beta.source.coop/cholmes/"
author_title = "[Taylor Geospatial Engine](https://tgengine.org/) Industry Fellow"
+++

fiboa is a new collaborative project to improve farm field boundary data interoperability and other associated agriculture data, that we [introduced](https://cloudnativegeo.org/blog/2024/04/introducing-fiboa/) a couple of weeks ago. This post complements our previous deep dive into the [follow-up post](https://cloudnativegeo.org/blog/2024/04/fiboa-core-specification-extensions/) core specification and its extensions. In that post, we mentioned that fiboa is not just a specification; it’s a complete system. It includes the entire ecosystem of data adhering to the specification, the discussions and conversations that evolve the specs, and of course, the community people who are building it all together. In this post, we introduce the initial tools, data, and community that form that ecosystem.

## Data

The goal of fiboa isn’t to create a data schema - the schema is a means to get at the goal of more data and more open data about field boundaries and agriculture to help us make better decisions. And indeed the best way to make a good data schema is not to go in a room and try to create the most perfect ontology - it’s to actually work with data and evolve the core specification and extensions to better represent real-world data. Our next step is to work with a number of organizations to ensure that their data can be represented in fiboa. To jump-start this process, we’ve converted a number of existing datasets and made them available on [Source Cooperative](https://source.coop).

For those unfamiliar with Source, it’s a data hosting utility provided by Radiant Earth, built with great support for [cloud-native geospatial formats](https://cloudnativegeo.org/). We’ll likely put most public datasets up on Source, as it’s a user-friendly platform. Anyone else is also welcome to host their fiboa-compliant data there. You can also easily host them on any cloud or simply use them locally, but it can be quite beneficial to put larger data up there, as it becomes easy for users to download just the subset of data they want.

{{< img src="images/20240417-fiboa-image6.png" alt="fiboa data on Source Cooperative">}}

The first of the datasets that was converted was [Field Boundaries for North Rhine-Westphalia (NRW), Germany](https://beta.source.coop/repositories/fiboa/de-nrw/description/). It was followed by 1.3 million [field boundaries for Austria](https://beta.source.coop/repositories/fiboa/austria/description/), plus boundaries for [Berlin / Brandenburg](https://beta.source.coop/repositories/fiboa/de-bb/description/), [Lower Saxony](https://beta.source.coop/repositories/fiboa/de-nds/description/), and [Schleswig-Holstein in Germany](https://beta.source.coop/repositories/fiboa/de-sh/description/). It’s pretty easy to convert existing datasets (more details in the ‘tools’ section below), so if you’re interested in contributing to fiboa, then converting and uploading a new fiboa dataset on Source is a great way to start. There are a few potential datasets listed in the [fiboa data repository tracker](https://github.com/fiboa/data/issues); if you’ve got ideas of other great datasets to contribute, don’t hesitate to add them to the tracker. We’re also hoping to get several commercial companies to contribute at least samples of their data implementing fiboa. The academic work that Taylor Geospatial Engine is funding is also going to harmonize and make publicly available some interesting datasets.

## Tools

As part of the initial release of fiboa, [Matthias Mohr](https://mohr.ws/) has built several tools to make the ecosystem more immediately useful. The main tools are all available from the [fiboa command-line interface (CLI)](https://github.com/fiboa/cli). This can be easily installed by running pip install fiboa-cli on any command line with Python 3.9 or above installed. It works like any command-line tool, and you can just type ‘fiboa’ on your command line and you can explore from there:

{{< img src="images/20240502-fiboa-ecosystem-image1.gif" alt="GIF of fiboa CLI">}}

The most important command is likely `validate`, which lets you check any GeoJSON and GeoParquet file to confirm whether it is a valid fiboa file. This operation is key to ensuring interoperability. It does no good to just have people ‘try’ to implement the specification with no way to ensure that they are doing it correctly. Validation will ideally be written into any workflow with fiboa data, to ensure all tools can count on it being represented properly.

All the validation is completely dynamic. fiboa files themselves point at the versions of core and extensions that they declare themselves as supporting, which means if there is a new release then they can immediately point at the new release file’s location and the validators will check against the latest. This means that there does not need to be a new release of the validators for each new extension release since it automatically follows where the file points. The validator works against local files as well as remote files.

The ‘describe’ tool is a favorite of mine, to quickly get a sense of the data.

{{< img src="images/20240502-fiboa-ecosystem-image3.png" alt="fiboa describe cli tool.">}}

The fiboa ‘create’ tool is also quite useful, as it can take a GeoJSON file and the intended schemas and transform them into the GeoParquet version.

And then there are a bunch of utilities to help with creating fiboa files and metadata. They include `create-geojson` which makes a fiboa GeoJSON from a fiboa GeoParquet, `create-geoparquet` which does the opposite, and `fiboa jsonschema` which will write out the valid JSON Schema for a given fiboa file. 

Matthias has put together a few nice tutorials, and all of these fiboa tools are covered in the ‘CLI Basics tutorial’. You can read the [text version](https://github.com/fiboa/tutorials/tree/main/cli-basics) of it, or watch [the video](https://www.youtube.com/watch?v=_5HKsw8OvF0). The tutorial also covers this [great Jupyter notebook](https://github.com/fiboa/tutorials/blob/main/cli-basics/load-fiboa.ipynb) that demonstrates how to do some analysis of fiboa data.

{{< img src="images/20240502-fiboa-ecosystem-image2.png" alt="fiboa cli demo.">}}

_Video tutorial on the fiboa command-line interface [on YouTube](https://www.youtube.com/watch?v=_5HKsw8OvF0)._

There is also a new converter tool, which can take non-fiboa data and help you turn it into fiboa data. Each converter must be implemented as part of the CLI library, but once it’s there then it’s available for anyone to convert any ‘official’ data to the fiboa version. Currently, there are only converters for open datasets in Germany and Austria, but it is relatively easy to add one. Doing so will make it simple for any user of agricultural datasets to convert for other regions. Matthis put together a great tutorial on how to easily create a new converter using the templates. A [text version](https://github.com/fiboa/tutorials/blob/main/cli-convert/README.md) and [video](https://www.youtube.com/watch?v=-SUDzug29Cg&list=PLENrKR4uOfvXH-bDf1ornXgO6NdEL25ZS&index=4) are available for this process as well. If you do create a new converter, please contribute it to the project so others can also use it.

## Community

While there’s a great start to the ecosystem above, we’re still in the early days. The key now is building an amazing community that can make this effort far bigger than we’ve dreamed of. We did the initial workshop in person to build up trust and connection as humans in an initial group, but our next goal is for the community to be centered online, in the style of the best open communities that we all know about. We hope to do more in-person events, but as a way to enhance the primary online collaborations. It will take some time to transition, and this is where we could use help! Mostly by joining in the effort, especially if you weren’t in the original workshop. We will not see this effort as successful until there are more people contributing than there were at the first workshop. 

We’ve just recently started forming the rituals and communications that form the community. The center will certainly be the [fiboa organization](https://github.com/fiboa/) on GitHub. This is where the [core specification](https://github.com/fiboa/specification), most of [the extensions](https://github.com/fiboa/extensions), the [core tools](https://github.com/fiboa/software), and the [discussion forum](https://github.com/fiboa/specification/discussions) live. It’s also where we’re doing all the [project management](https://github.com/orgs/fiboa/projects/2) of all the different pieces. We aim to add tags in our projects on ideas for good first tasks to help beginner contributors find easy ways to get involved.

We do think some real-time discussion can really move things forward. We have bi-weekly Zoom meetings for progress checks (see [project board](https://github.com/orgs/fiboa/projects/2/views/3)). Yet we strive to follow best practices for online communities, aiming to make all decisions fully online in the repositories, and posting everything that happens, so that the Zoom meetings are a complement to the core running of the project and not how the project is run. We’ll also aim for some ‘break out’ sessions to enable higher bandwidth collaboration on key topics like defining new extensions, delving into core spec questions, or giving deeper demo sessions. Anyone and everyone is welcome to join both the bi-weekly calls and any break-out sessions. You can get these calls added to your Google calendar by joining the [fiboa Google Group](https://groups.google.com/a/tgengine.org/g/fiboa). Join the #fiboa Slack channel on the [Cloud Native Geospatial Slack](https://join.slack.com/t/cloudnativegeo/shared_invite/zt-2i37pc3nm-9bXiRHYrI6fH5qFh2VaLFA) for async / chat communication.

## Join us!

There are many ways to contribute, some mentioned above. If you’d like to learn more (even if you aren't ready to contribute), join our Slack or jump into the bi-weekly meetings. All are welcome to just join and observe. And if you just want to ‘do something’ then the best way is to actually try to take an existing field boundary dataset and try to convert it to fiboa, and uploading it to Source Cooperative. Matthias’s tutorials should guide you. If any questions remain, please feel encouraged to ask them on the fiboa Slack channel. We are also planning to publish more information, documentation, and tutorials in the future. But until then, just jump in and get in touch.

We look forward to working with you, and building this project together!
