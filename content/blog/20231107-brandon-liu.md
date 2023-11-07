+++
date = "2023-11-07T08:00:00-07:00"
title = "Interview with Brandon Liu"
tags = [ ""
]
summary = "An interview on Protomaps, cloud-native innovation, and shaping tomorrow’s geospatial landscape."
+++

Brandon Liu, a technologist working at the vanguard of mapping, global network infrastructure, and vector graphics, has made an outsized impact on the open source geospatial community. The founder of [Protomaps](https://protomaps.com), an interactive mapping company established in 2019, Brandon has created a map project that has reshaped how we interact with geospatial data on the web. His creations include PMTiles, a serverless solution that optimizes the storage and retrieval of millions of map tiles in the cloud. In his current role as a Technology Fellow at [Radiant Earth](www.radiant.earth0, Brandon continues his focus on advancing the geospatial domain through innovation, integration, and knowledge sharing. In this Q&A, we explore Brandon’s journey, the innovative work of Protomaps, his perspectives on the geospatial technology landscape, and his vision for the future of the field. 

### Could you provide an overview of your journey into geospatial technology? What sparked your interest in this field, and how did it lead to the creation of Protomaps? 

My journey in geospatial started when I discovered OpenStreetMap (OSM) in 2012. I used OSM data to power a few of my own civic tech projects, like a [1980s street view app](https://80s.nyc), and began building web mapping applications freelance for companies and humanitarian organizations. 

For me, the "full-stack" nature of mapping has always been its central appeal. Geo is powered by domain-specific data structures and algorithms. Its end goals are not defined by hard technical requirements, but by human factors like: Do users recognize key city names and landmarks on the map? Is a map visualization a truthful representation of the data? 

Through a decade of making web maps, I repeatedly ran into the same pain points for visualizing vector data using open source tools. No client project I worked on could dedicate a years-long investment in foundational infrastructure. So Protomaps is the answer to those pain points - the distillation of a decade of open source mapping experience that I hope advances the state of the art. 

### Protomaps offers a range of innovative solutions, including PMTiles and a novel approach to building a business. Can you share some real-world applications of how your approach has transformed how we interact with geographic data?

Protomaps is a bootstrapped business - my mission is to demonstrate that it is possible for open source developers to make a living from their work. Being an independent business influences the design of formats like PMTiles and its surrounding ecosystem. A company with external demands on its monetization will integrate vertically: SaaS and proprietary services, with some open source frontend sprinkled in, remain the most investor-friendly business model. 

Being free from the constraints of a typical tech company means Protomaps is a better fit for applications underserved by the traditional software industry. Journalism and the public sector are two areas that have adopted PMTiles. Other use cases I’ve learned about in the past month include [wildfire mapping in British Columbia](http://lens.pathandfocus.com) and a [storytelling app for indigenous communities](https://explore.terrastories.app).

### Cloud-native approaches are becoming increasingly important in geospatial technology. What are the key benefits and challenges of using cloud-native solutions in this domain, and how does Protomaps leverage them effectively?
 
Data analysts and stakeholders always want to see “all the data, on a map.” Making this possible in the web browser - the most ubiquitous and open computing platform -  is a key benefit of cloud-native: it’s not a walled garden like Desktop GIS or smartphone App Stores. 

A key challenge of cloud-native solutions is ensuring that the move to the cloud does not create vendor lock-in. For the PMTiles ecosystem, it’s important to have first-class support for both the AWS Cloud’s serverless platform (Lambda) and Cloudflare (Workers). Though both platforms are proprietary, users of PMTiles should be able to migrate freely between them. 

A stretch challenge for "cloud-native" is to work without the cloud at all. Many geospatial applications need to be air-gapped or work in developing countries with limited internet connectivity. A big hard drive there is more useful than S3! The PMTiles ecosystem works just as well off the cloud, though, and for that reason, it’s been adopted in field mapping and aviation. 

### Object storage-based strategies like STAC and PMTiles are becoming increasingly important. How do these strategies enhance the accessibility and adoption of open geospatial data, and what steps will you take to advocate for their implementation?

Object storage is a de facto standard that creates near-perfect competition between cloud providers. Users can adopt with confidence that their platform won't be deprecated on a whim by companies, and are free to migrate to other providers. This isn't possible with closed platforms like Google Earth Engine. 

A similar development happened for videos on the web. You used to need Flash or RealPlayer to view movie clips, but Range Requests made streaming video possible with plain HTTP. That advancement also led to the standardization of <video> elements in browsers. In the same way, the Protomaps ecosystem brings interactive geospatial visualization to the browser, agnostic to what object storage it lives on, all using web standards. 


### Let’s talk about your role as a Technology Fellow at Radiant Earth. Can you provide insights into specific initiatives you’re working on to enhance the efficiency and accessibility of geospatial data?

My goal as a Radiant Earth Fellow is to support the community of Source Cooperative users through tooling. I've described vector data as the "missing half" of cloud-native geospatial. The PMTiles format already appears in several Source repositories. In the course of my fellowship, I've focused on improving and documenting three interlinked command line tools: `pmtiles,` `gpq,` and `tippecanoe` to visualize and process vector data.

Beyond datasets on Source, the Protomaps ecosystem meets developers where they are by integrating with popular visualization libraries. I've enhanced the MapLibre GL mapping library, shipped v1.0 of OpenLayers integration, and will be further improving the integration with Leaflet. The OpenLayers plugin is already being used in the automatic preview on Source Cooperative. 

### The field of geospatial technology is rapidly evolving. What emerging trends or technologies do you find most exciting or disruptive, and how do you see them shaping the future of the industry?

WebAssembly is one technology that has been emerging for half a decade now, and its impact has been limited relative to its hype. I think that hype is real for Geospatial WebAssembly: serious geo applications need access to heavyweight libraries like DuckDB, GEOS, and GDAL, and the bundled size of WASM apps is an acceptable tradeoff. Whether the tools use WASM or not, I see a greater focus on data visualization and full analysis directly on the web. Anyone interested should check out Kyle Barron's work on GeoParquet in the browser.

A major trend in the technology industry and fundraising environment, beyond geospatial, is the adoption of licenses like the Business Source License instead of permissive ones. Companies that spend years developing software rightly refrain from giving it away for free to larger competitors. A consequence is that smaller or more civic-minded applications also lose access to that software. In this new licensing atmosphere, I see a greater role for foundations like Radiant Earth and the Cloud-Native Geospatial Foundation to take the lead on open source. 

### Finally, could you share any exciting developments or future projects we can look forward to from Protomaps, and how can individuals and organizations stay connected and engage with your work?
 
The development I'm most excited about for 2024 is taking the Protomaps project global. Protomaps' core data product is an openly licensed cartographic tileset, and its focus up to now has been North America and Western Europe, meaning most users view the map in languages like English or French. Features I’m working on now will enable deploying the map in more than 25 languages; together with global datasets on Source Cooperative, anyone can build an affordable mapping application for an audience in South America, Africa, Asia, or anywhere in the world!

One channel I’ve adopted in 2023 is [GitHub Sponsors](https://github.com/bdon) - I’ve found it a great way to connect with an audience of developers working with the technology every day. I also post updates on [Mastodon](https://mastodon.social/@bdon) and [X](https://twitter.com/bdon), and you can find me at open source geo conferences on multiple continents!
