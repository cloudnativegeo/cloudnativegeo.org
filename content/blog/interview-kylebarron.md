---
date: "2024-12-10T1:00:01-04:00"
title: "Interview with Kyle Barron on GeoArrow and GeoParquet, and the Future of Geospatial Data Analysis "
tags: [ ""
]
images:
  - /img/20241209-kylebarron.png
summary: "Kyle Barron, cloud engineer at Development Seed, builds open source tools and infrastructure that process and visualize geospatial data."
---
### You’ve spent years figuring out how to visualize large geospatial datasets in web browsers. Can you tell us a bit about your background and what initially drew you to this area?

I have a bit of a nontraditional background; I have virtually no official training in geography or computer science. In college, I was interested in urban and environmental economics, trying to understand how policies shape cities and the environment. I planned to pursue a PhD in economics and after college worked for a health economics professor at MIT for two years. 

That time was really beneficial: I learned how to manage and analyze large medicare datasets, but more importantly, I learned that I enjoyed the data analysis and coding aspects more than the research side. I eventually accepted that pursuing a PhD was not the right choice for me, and left that job to hike the Pacific Crest Trail, a 2,650-mile hiking trail from Mexico to Canada through California, Oregon, and Washington. Over those five months of hiking, I decided to try to switch to a career in geospatial software or data analysis.

After finishing the trail, I lived with my parents for a while to try and make this career switch without going back to school. This was a formative time for me, intellectually. In the process of making an [interactive website dedicated to the Pacific Crest Trail](https://nst.guide), I learned about geospatial concepts like spatial reference systems. I learned how to manage geospatial data in Python with geopandas and shapely. I learned JavaScript and how to create simple websites. I learned about vector tiles, about the Mapbox GL ecosystem. I learned how to create my own basemap data: my own OSM vector tiles and my own derived OSM style. My own hillshade data and contour lines derived from USGS data.

What really drew me to the browser was its broad accessibility. ArcGIS and QGIS are specialized tools that either cost an arm and a leg or are difficult for unsophisticated users to install. Meanwhile *everyone* has access to a web browser. Web browsers are the way that the general public interacts with data. I wanted to make my world accessible to the general public in a visual, interactive way.

Luckily, towards the end of this project, as I was contributing bug fixes to deck.gl, the core developers of deck.gl had just formed the startup Unfolded, and offered me a job. I was elated that my bet was successful, that I was able to transition into a new field that I found exciting, on my own terms and without going back for another degree.

### Let’s jump right into GeoParquet and GeoArrow. In layman’s terms, what are these tools, and why are they creating such a buzz in the geospatial data community?
[GeoParquet](https://geoparquet.org) and [GeoArrow](https://geoarrow.org) are both ways to speed up handling larger amounts of geospatial data. Let’s start first with GeoParquet, since that’s a bit more approachable to understand. 

GeoParquet is a file format to store geospatial vector data, as an alternative to options like Shapefile, GeoJSON, FlatGeobuf, or GeoPackage. Similar to how Cloud-Optimized GeoTIFF builds upon the existing GeoTIFF and TIFF formats, GeoParquet builds upon the existing Parquet format for tabular data. This gives the GeoParquet format a head start because there are many existing libraries to read and write Parquet data that can be extended with geospatial support.

There are three things that excite me about GeoParquet: it’s **cloud-native**, so you can read portions of the file you care about directly from cloud storage, without downloading the entire file. It **compresses** very well and is **fast to read and write**, so even in non-cloud-native situations, it can speed up workflows. And it **integrates well with other new technologies** such as GeoArrow.

#### Cloud-Native
GeoParquet 1.1 introduced support for spatial partitioning. This makes it possible to fetch only specific chunks of a file according to a spatial filter. Note that spatial partitioning is a slightly different concept to spatial indexing. In a format like FlatGeobuf or GeoPackage that performs spatial indexing, it records the position of every single row of your data. This is often useful when you want to quickly access individual rows of data, but it prevents effective compression and becomes harder to scale with large data because the index grows very large. In contrast, spatial partitioning uses chunking, where instead of indexing per row, it records the extent of a whole group of rows. This provides a lot of flexibility and scalability when writing GeoParquet data. By adjusting the chunk size, the writer can choose the tradeoff between index size and indexing efficiency.

The upside of spatial partitioning is that an entire group of data is indexed and compressed as a single unit. The downside is that if you do want to access only a single row, you’ll have to fetch extra data. The sweet spot is when you want to access a collection of data, say in one spatial region. (If your access patterns regularly care about single rows of data, a file format like FlatGeobuf or GeoPackage might be better suited to your needs. GeoParquet is tailored to bulk access to data.)

GeoParquet also lets you fetch only specific columns from a dataset. If the dataset contains 100 columns but your analysis only pertains to the geometry column plus 3 other columns, then you can avoid downloading most of the file. For example, with [stac-geoparquet](https://github.com/stac-utils/stac-geoparquet), a user might want to find URLs to the red, green, and blue bands of Landsat scenes within a specific spatial area, date range and cloud cover percentage. This query is much more efficient with GeoParquet because it only needs to fetch these six columns.

#### Effective compression
GeoParquet also excels even when you don’t care about its cloud-native capabilities. It compresses extremely well on disk and is very fast to read and write. This leads GeoParquet to be used as an intermediate format for analysis, such as GeoPandas, where a user wants to back up and restore their data quickly.

For example, in [Lonboard](https://github.com/developmentseed/lonboard), a Python geospatial visualization library I develop, we use GeoParquet under the hood to move data from Python to JavaScript. This isn’t a cloud-native use case, but GeoParquet is still the best format for the job because it compresses data so well and minimizes network data transfer.

#### Integration with GeoArrow
GeoParquet is a file format; when you read or write GeoParquet you need to store it as some in-memory representation. This is where GeoArrow comes in. It’s a new way of representing geospatial vector data in memory and a way that’s **efficient to operate on** and**fast to share between programs**.

GeoParquet and GeoArrow are well integrated and have a symbiotic relationship, where growing adoption of one makes the other more appealing. The fastest way to read and write GeoParquet is to and from GeoArrow. But GeoArrow is not strictly tied to GeoParquet: it can be paired with any file format.

For example, GDAL’s adoption of GeoArrow made it **23x faster to read FlatGeobuf and GeoPackage into GeoPandas**. Historically, GeoPandas and GDAL didn’t have a way to share a collection of data at a binary level. So GDAL (via the fiona driver) would effectively create GeoJSON Python objects for GeoPandas to consume. This is horribly inefficient. Since GDAL 3.6, GDAL has supported [reading into GeoArrow](https://gdal.org/development/rfc/rfc86_column_oriented_api.html) and since GDAL 3.8 it has supported writing from GeoArrow.

I’m just one of a bunch of people in the GeoParquet community. We have some very smart collaborators, including Chris Holmes, Joris Van den Bossche, Dewey Dunnington, Even Rouault, Tim Schaub, and many more.

### We continue to see improved performance in both user devices and the cloud. How do you envision the future of geospatial data in web browsers? What kind of use cases would you like to see enabled? 

I think GeoParquet and GeoArrow will make it possible to have full GIS systems in the browser.

I’m working on making it easier to use and visualize GeoParquet and GeoArrow in browsers. I’m making steady progress on [geoarrow-rust](https://github.com/geoarrow/geoarrow-rs), an implementation of GeoParquet and GeoArrow in Rust with WebAssembly-based bindings to JavaScript. With this project I’m collaborating with engineers at Meta to [access Overture data directly from the browser](http://explore.overturemaps.org). Downloading an extract from the website will perform a spatial query of Overture GeoParquet data without any server involved.


Interacting with the cloud from browser applications presents interesting problems of data locality. In a web application using a GPU-powered renderer like [deck.gl](http://deck.gl), there are three environments with different resources: the cloud, the browser, and the GPU. The cloud has virtually limitless capacity, but with limited internet bandwidth, choosing what subsets of data to download from the cloud to the browser is a challenging problem. Furthermore, the GPU has fewer memory resources than the main browser process, which means that a further subset of the browser data must be selected to copy into the GPU.


What we’re doing with Lonboard is similar. When data is on the GPU, it’s really fast to visualize. But the GPU tends to have smaller amounts of memory, and thus able to handle smaller quantities of data. Python has more memory but you need to manage what data you send between Python and the GPU. Then the cloud is just another extension of that. There are really interesting problems around: what data do you move between the cloud to the server (Python) to the browser to the GPU.
In general I find boundaries the most interesting problem. When do you need to move data across boundaries; how can you minimize what data you need to move, and how can you make the movement most efficient when you actually do need to move it.


### Beyond technical expertise, what books, articles, podcasts, even movies have significantly influenced your career path? 

The specific experience with the largest non-technical influence on my career has been my time in the outdoors and especially hiking the Pacific Crest Trail. It piqued my interest in thinking about data for the outdoors and climate and gave me a strong base of motivation for learning how to work with geospatial data. I think that having motivations and ideas around *what to create* is much more important than learning *how* to do something. There’s enough technical material on the internet to learn pretty much whatever you want. But whenever learning something new, and especially when learning by yourself, you’ll always have a period where things just don’t make sense. It’s been really useful for my learning to have an end goal in mind that keeps me motivated to press on through the “valley of despair” of new concepts.

I’d also point to a video by prolific youtuber and science communicator Tom Scott: “[The Greatest Title Sequence I've Ever Seen](https://www.youtube.com/watch?v=mUF4afxMpQk).” It discusses an introductory sequence to a British TV show and notes how much attention to detail there was, even when virtually no one would notice all those details. I love this quote:

> “Sometimes, it’s worth doing things for your craft, just because you can. That sometimes it’s worth going above and beyond, and sweating the small stuff, because someone else will notice what you’ve done.”

I try to strive for excellence even when no one’s watching. And in my own career, I’ve noticed how this attention to detail came in handy in unexpected ways. Where by going above and beyond in one project I learned concepts that made later projects possible. 

I should also note that a collection of people online have been really strong influences. Vincent Sarago and Jeff Albrecht were two of the first people I met in the geospatial community and they’ve been great mentors. And the writings and code of people like Tom MacWright and Volodymyr Agafonkin have taught me a lot. 
