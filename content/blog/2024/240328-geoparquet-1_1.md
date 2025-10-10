+++
date = "2024-03-28T15:55:58-07:00"
title = "Coming Soon: GeoParquet 1.1"
tags = [ ""
]
summary = "Some updates on the upcoming 1.1 release of the GeoParquet specification which will include a bounding box column and GeoArrow encoding."
author = "Chris Holmes"
author_url = "https://beta.source.coop/cholmes"
author_title = "Radiant Earth Technical Fellow"
+++

On Monday, we had our regular GeoParquet community meeting, and everyone agreed it's a pretty exciting time, but that we need to tell people more about what we're up to. We're feeling 'feature complete' for a version 1.1 release of the specification, and so wanted to give all implementors a heads up so they could try it out and give any last feedback. And to also just share what's been cooking. We'll have a full announcement release when the 1.1 release goes out, so consider this a bit of a preview.

The focus for version 1.1 has been on 'spatial optimizations'. We actually decided to not include any spatial index or hints in GeoParquet 1.0. Which may seem surprising, but we really wanted to focus on interoperability &ndash; making sure that everyone writing geospatial data into Parquet would write it the same way. We knew that there was a whole lot that could be done to make it a better spatial format, but we wanted to give more time for experimentation with different approaches. In the early days of GeoParquet (version 0.2) there was a really great talk from Eugene Chopish that explored the various possibilities. If you want a really great deep dive do check out [his talk on Youtube](https://www.youtube.com/watch?v=uNQrwMMn1jk).

Two of the ideas he proposed saw significant community experimentation and have proven to be quite useful. Both were proposed as Pull Requests, and after extensive discussion and implementation they have both landed on 'main' and will soon form the basis of the 1.1 release.

The first introduces a bounding box column, and the second brings GeoArrow encoding as an option.

## Bounding Box Column Definition

One key insight has been that Parquet is such a great format that we can use some properties inherent to it instead of just adding a full spatial index.

Parquet is a columnar format, meaning its organized by columns instead of rows. This makes it very fast to access only one or two fields, since the rest don't need to be read. But it uses this construct called a 'row group' to provide fast access to a set of rows. But it's more of a 'chunk' of rows, usually at least hundreds, though you can set the size of your row group fairly easily.

The cool thing is that there are lots of built in 'summary stats', so Parquet readers can easily jump to just the row groups they need.

What this meant was that you could actually spatially optimize a GeoParquet file without needing a defined spatial index construct. So with GeoParquet 1.0 you could have a file that loaded in QGIS like this. You'll notice that the whole world just loads everywhere at once.

This is atypical for spatial data. We're all used to files loading something more like this, where the chunks are loaded spatially:

The cool thing is that both of the files loading are GeoParquet &ndash; the files are just organized a bit differently. The different loading also means that clients can access the chunks more efficiently, as long as it's set up right.

All you need to do is just order things spatially. In early experiments people would add a space filling curve like quadkey or S2 as an extra column. And then you could use that in your query. And it worked well! The Parquet file would use the stats for that column efficiently, and so you could just add the quadkey to your query and you'd have a spatial index.

We thought about standardizing on something like this, but it wasn't clear which one to pick.

But a more sensible way emerged. [Overture's](https://overturemaps.org/) first release (which wasn't even yet GeoParquet, just Parquet) had a BBOX column, using the 'struct' construct of Parquet to put all four values in a single column.

The nice thing about this is that the you can order / organize the data in any spatial way that you want, and Parquet readers can use the stats on the x and y values to efficiently get the right data.

Early experiments supported the notion that if you got the right bbox struct and can do 'predicate pushdown' &ndash; ie make use of the nested structures &ndash; then the performance is stellar &ndash; for example 1.5 seconds versus 4 minutes against large datasets. The big question for us was whether enough readers would support reading the 'struct'.

The alternative was to just put the 4 bounding box values at the top level. Which felt not nearly as clean, and not really taking advantage of what Parquet offers.

Thankfully our [big survey](https://github.com/opengeospatial/geoparquet/discussions/192) revealed that most every major implementation that we want to support GeoParquet could take advantage of the stats from the struct for more efficient indexing. And the discussion even nudged a few implementations to fully support the predicate pushdown.

The changes in the spec are actually quite minimal, just a couple new paragraphs explaining how to represent the bounding box as a struct. The spec does not say anything about how to spatially organize the data, but most tools that support writing GeoParquet data with the bounding box will automatically spatially optimize the data.

The feature is 'opt-in' &ndash; you can make compliant GeoParquet without adding the BBOX. But we suspect that most geospatial tools will start to understand it, and to also produce it by default. And since it's based on native Parquet structures most non-spatial tools reading Parquet will also be able to take advantage of it as well.

The result is that any spatial filtering can be much faster. And if your data is large, and/or it's accessed over the network, then the speed improvements can be dramatic. Jake Wasserman, who really drove this PR, [shared some compelling results](https://github.com/opengeospatial/geoparquet/discussions/188#discussioncomment-8909348) from making use of the new feature in Overture & DuckDB:

In short the time to query 891 rows from a 2.2 billion row dataset went from almost 2 hours to 34.75 seconds, a 191x improvement.

## GeoArrow Support

The other major improvement that just landed is [GeoArrow](https://geoarrow.org/) support. GeoArrow is an incredible project, bringing geospatial support to [Apache Arrow](https://arrow.apache.org/). The origins of GeoParquet actually rest in GeoArrow, which is a much more ambitious project, as it can lead to dramatic performance improvements in working with geospatial information. The recently announced [lonboard](https://developmentseed.org/lonboard/latest/) project from Kyle Barron and Development Seed shows off some of what's possible:

GeoArrow makes it possible to render millions of points directly in the browser, and also enables seamless passing of the data between different programming languages.

GeoParquet is generally used in conjunction with GeoArrow, as the format to store the data in, or to transfer it online, and having an option to encode GeoArrow directly means that it's much faster to parse from GeoParquet. But using the encoding in GeoParquet also has a number of other advantages. The key is that GeoArrow introduces a columnar geometry format. Arrow and Parquet are both columnar formats, meaning that all the data is stored in columns, not rows. But the core of GeoParquet has been 'Well Known Binary', which is not a columnar format &ndash; it is just a 'blob', a binary that is opaque to any standard Parquet or Arrow tooling. The new Bounding Box column introduces a structure that isn't opaque, the bounding points are columnar, and so standard tooling can make use of it. GeoArrow goes a step further and makes it so the geometry format itself is columnar.

The advantages of this are most apparent in the case of points. If you add a bounding box around a point then it ends up just replicating the point a couple more times. And if the point is well-known binary than you need that bounding box for efficient spatial queries. But if the point itself is columnar then the bounding box struct isn't really needed, as all the tooling can use the Parquet stats directly, since it's not an opaque blob. The advantages are most clear with points, where you don't need to replicate the data just for the bounds. But lines and polygons can also be represented in a columnar way, and the bounds for those can easily be calculated, just like the stats are constructed for other structs &ndash; reporting the min and max values.

There are a number of potential advantages to having a columnar geometry, and generally it should work better with tools that understand Parquet but don't know anything about 'geospatial'. It's always been a goal to include an encoding option for a columnar format, so it's great to see it land. Adoption of this will likely be slower than the bounding box column, as many tools will need to write a completely new parser (most libraries already have a WKB parser). But it will ultimately make things work faster, and open up more possibilities for tooling to stream directly from it. Eventually using the GeoArrow encoding may make it so you don't even need to use a bounding box column for spatial queries, but we anticipate it'll take awhile for all the tooling to get there. The two features were designed to be completely complementary, so there is no problem to use both.

A huge thanks to Joris Van den Bossche and Dewey Dunnington for all their work on GeoArrow, and for driving this PR to completion.

## Please Test!

If you are an implementor of a GeoParquet tool we highly recommend trying out the new features and giving us feedback, as it'll be harder to change after the 1.1 release. We aren't cutting a 'beta' release, as we don't want there to be some small number of files that everyone needs to understand. So if you're implementing this just use 1.1 for version number, as we don't anticipate any changes. And if there are changes then all the tools will just update so they use it right.

If you're a data user you can try out the bounding box column today &ndash; all the latest Overture releases support it. And you can use tools like DuckDB to make use of the column if you just form your queries right. GDAL/OGR is also implementing it, to automatically take advantage of the column if it's there, and to be able to write out new data to it. GDAL/OGR has also been supporting GeoArrow, but there are a few small tweaks needed to get it to 1.1 GeoParquet compliance.

Thanks to everyone who contributed to these two pull requests and the tooling around them &ndash; it's been a really great community effort.