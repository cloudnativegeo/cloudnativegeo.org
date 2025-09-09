---
date: 2025-08-26T12:00:00-00:00
title: "Redefining cloud native with the Coalesced Chunk Retrieval Protocol"
author: "[Jarrett Keifer](https://www.linkedin.com/in/jarrettkeifer)"
author_title: "Senior Geospatial Software Engineer, Element 84"
summary: "What happens if we question current assumptions around CNG
and imagine what it could be if we were to redefine it with new
technologies? The Coalesced Chunk Retrieval Protocol (CCRP) is
one idea born of this thinking, aiming to help make CNG more
efficient and easier for both data consumers and producers."
---

{{< img src="images/250826-ccrp_logo.svg" alt="The CCRP Logo">}}

In our ongoing series on geospatial raster data formats, [Julia
Signell](https://www.linkedin.com/in/jsignell/) and I have been exploring the
finer points of array data storage. Throughout our research we’ve found that
chunking -- breaking a large dataset down into smaller pieces for individual
storage and retrieval -- is universally relevant regardless of data format.
Chunking, as we’ve seen, is an absolutely necessary strategy for making large
datasets usable, [but in the cloud era it has become something
tyrannical](https://element84.com/software-engineering/chunks-and-chunkability-tyranny-of-the-chunk/),
making data access efficiency strictly tied to chunk alignment.

Diverge from an access pattern aligning with the dataset’s chunking scheme and
compounding inefficiencies will cripple data access at scale. Pretend, for
example, we are an official in Chico, a city in the central valley of
California near the foothills of the Sierra Nevada, who wants to examine
changes in monthly average maximum temperatures in the city over the years 2010
to 2020 to understand possible increases in air conditioner usage. Say we have
daily maximum temperature data stored in cloud object storage and chunked into
pieces covering the entire state of California for a given day.

Our access pattern is misaligned! We only want to see data for Chico, other
areas are not under our jurisdiction, so we have no need to download data for
the rest of the state. But we cannot get only the data we want given the way
this dataset is chunked. We want a small part of many large chunks, meaning we
have to make many requests for lots of unwanted data, which is inefficient.

The cloud has given us the ability to store petabytes cheaply, but we’ve lost
our ability to access that data efficiently without considering chunking,
access patterns, and how to mitigate misalignment. But this tyranny of the
chunk doesn't have to be permanent. We've solved hard problems before; object
storage itself was once revolutionary. I believe it is time to solve the next
layer: making that stored data actually accessible at the speed of analysis,
not the speed of HTTP requests.

To that end, I want to introduce a new idea I’m calling the [Coalesced Chunk
Retrieval Protocol (CCRP)](https://ccrp.dev) as a potential new definition of
“cloud native” for chunked data. Chunked file formats on local storage once
provided an effective abstraction preventing users from having to think about
details of data storage and layout, and CCRP aims to get that abstraction back
in the cloud, for both raster and tabular data.

But this post isn’t just me offering up an idea wholesale. This is an
invitation to the community to collaborate on building cloud native better.
This is a chance to work together on making the ecosystem stronger and to
reconsider what cloud native really means. If you work with large chunked
datasets, I want to hear from you. If you're building data infrastructure, I
want your technical feedback. Or, if you have other ideas entirely, let’s hear
them\! We don’t have to just accept the status quo, we have the chance to
define the future of cloud native geospatial by what we build together today.

## The irony of "cloud native"

When we say a data format is "cloud native," we usually mean the data layout is
optimized for access via an object store API, like S3's. But here's the thing:
S3 was designed for web assets, not scientific data. Cloud object storage is
great for storing huge datasets, but it's terrible for reading many small
pieces at once. In the worst case, the object model requires each chunk of a
dataset be read via a separate HTTP request. A data scientist wanting a
specific slice of a large dataset might need 10,000 data chunks, leading to
10,000 separate, high-latency HTTP GET requests from their laptop.

This forces data producers to choose between two sub-optimal options: use huge
chunks that cannot provide granular data access, or small chunks that force
users into a query pattern dominated by time spent requesting data instead of
receiving it. As a result, chunk sizes have grown in the cloud, but this means
that misaligned access can incur significant overhead pushing and extracting
bytes that aren’t wanted.

Not infrequently, what results is an absurd situation. Savvy users end up
having to maintain their own, rechunked mirrors of their most important
datasets to get around these inefficiencies. Data producers end up having to
duplicate their datasets using multiple chunking schemes to try to address
common access patterns, and hope that their users understand when to use which
copy. And both sides spend time and energy arguing about what is the “right”
way to chunk.

All of this is wasted compute and storage, wasted time and money, and wasted
cognitive capacity for users and producers alike.

## Enter CCRP

### What is CCRP?

CCRP is a protocol that defines a way to make a single API call to fetch
multiple data chunks from cloud storage at once, eliminating the network
latency that cripples big data analysis. It builds on existing patterns like
HTTP and REST, and aims to feel immediately familiar.

With CCRP, a client makes one single, batch request specifying all the chunks
they need using some combination of dimensional filtering and coordinate
slicing (like in xarray when [selecting variables from a
dataset](https://docs.xarray.dev/en/stable/user-guide/data-structures.html#dataset-contents)
and [slicing arrays based on
coordinates](https://docs.xarray.dev/en/stable/user-guide/indexing.html#indexing-with-dimension-names)),
as appropriate. The CCRP API, running inside the cloud next to the object
store’s backing on-disk block store, grabs the bytes for all matching chunks
from the block store with near-zero latency and streams the combined data back
to the client in a single response.

CCRP offloads the responsibility of determining what chunks to fetch from the
client. Its job is to resolve a set of chunks that match a client’s query, and
return them. The client needs only to map a user query to the dimensions
exposed by CCRP, and no longer has to concern itself with chunks and byte
ranges.

**Think of this like GraphQL, but for chunked datasets in cloud storage.**

GraphQL originated from a version of the same problem with REST-style APIs. For
example, to get a user, their posts, and their comments, you had to make three
separate API calls: `/users/1`, `/users/1/posts`, and `/users/1/comments`.

GraphQL solved this by letting clients send one single query describing
everything they need, and they get it all back in one round trip.

CCRP does for data chunks what GraphQL does for web resources. It replaces
potentially thousands of slow, chatty requests with a single, efficient one. It
offloads chunk byte range calculation from the client side, and allows for read
coalescing where it would otherwise be impossible. Doing so allows data to be
chunked into smaller pieces to facilitate more granular access, mitigating the
penalty of misaligned access patterns.

In our original example of wanting temperature data for Chico,
California, we saw how a query with a small area and large time range was
misaligned to the chunking of the target dataset. To address this misalignment, we
could optimize the chunking for our use-case by breaking up the chunks into
smaller areas and aggregating them across longer periods of time. Thus we could
query for our small area and large time range with less requests and less
unwanted data.

Except then we’d compromise efficiency for users that want to get temperatures
for all of California on only a given day.

To balance both needs we have to make our chunks small, both spatially and
temporally. Small chunks increase access pattern alignment by reducing the
amount of unwanted data we have to download for any given request. But small
chunks with the current object storage access model forces users to make even
more HTTP requests to retrieve what they need, which can become untenably
inefficient when performing queries at scale. CCRP, by performing read
coalescing server-side, allows clients to read a vast range of chunks with a
single request.

### Why this matters now

Data volumes are exploding. Chunking strategies are getting more complex. The
burden on data consumers and producers alike is growing. As we look to the
future, the current status quo appears more and more unsustainable. We need to
find a way to address the problems before they grow too large.

### What makes CCRP different?

Other solutions have proposed similar advantages. Things like
[OPeNDAP](https://www.opendap.org), [OGC EDR](https://ogcapi.ogc.org/edr/), and
[TileDB](https://www.tiledb.com) come to mind, but CCRP is different.

**It decouples the logical data model from the physical layout.**

The object model is an erroneous abstraction for many large chunked datasets.
Modern cloud native formats store datasets across multiple objects. Objects are
inherently one-dimensional byte streams; linearization of multidimensional data
into objects means that the data layout cannot preserve all possible spatial
proximity. Fulfilling logical queries often requires mapping the query to
multiple disjoint byte ranges within an object’s one-dimensional byte stream
and to byte ranges within multiple objects.

With CCRP, clients can request data in a way that makes sense for their
analysis, e.g., "give me this time series". They don’t have to concern
themselves with how a data provider physically organizes data within or across
files/objects, e.g., “I want these bytes from this object, and those bytes from
that object…”. The API translates requests into an optimal plan for fetching
the requested chunks, unencumbered by the erroneous object abstraction in the
middle.

**It's a lightweight “byte broker”, not a compute engine.**

The API's only job is to find whole chunks and forward their bytes. It doesn't
decompress, filter, or process the data -- it operates on chunks alone. This
makes it fast, scalable, and simple.

**It should be a native cloud primitive.**

This isn't just a proxy in front of an object store -- though the reference
implementation will likely be something to this effect. For maximum
performance, this should be a parallel, first-class interface into the cloud
provider's internal block store, just like the S3 API is today, to eliminate
extra network hops and get around the erroneous object
model.

Think about AWS's recent [S3 Express One
Zone](https://aws.amazon.com/s3/storage-classes/express-one-zone/) or their new
[S3 Tables](https://aws.amazon.com/s3/features/tables/) and [S3
Vector](https://aws.amazon.com/blogs/aws/introducing-amazon-s3-vectors-first-cloud-storage-with-native-vector-support-at-scale/)
stores. Cloud providers are recognizing that different data patterns need
different interfaces. CCRP is proposing the same for chunked raster and tabular
data.

**But it can be adopted incrementally.**

We don’t have to wait for cloud providers to start using CCRP. We can begin
with proxy implementations to show the value and build out client-side tooling
while the ecosystem evolves toward native cloud support.

As a parallel interface to data in an object store, CCRP is
backwards-compatible. Clients with older tooling can continue to interface
directly with the objects backing a CCRP dataset.

**The goal is an open standard, not a product.**

This is a missing piece of global data infrastructure. The goal is to create a
compelling specification that all cloud providers can and will implement,
making data access better for everyone.

## From Chico to California: an detailed example

To illustrate how this solution scales, let’s go back to our hypothetical
weather dataset and assume we’ve made the chunks smaller than the whole state
of California to better align to our Chico user’s query. Now that the city of
Chico has proven their analysis method at the small scale, the state of
California wants to repeat the analysis at the larger statewide scale.

How exactly does increasing alignment for a small query affect our ability to
query at a larger scale? We can work through a detailed example to better
understand what has to happen when querying cloud-native data formats through
an object store API, how chunk size affects HTTP requests, and to see how CCRP
allows for more efficient queries.

We need to better define our weather dataset for this example. A realistic
weather dataset might be gridded at 0.01° resolution (a 1 km nominal resolution
as measured near the equator), with samples every hour. We’re still interested
in temperature data, but now we have a larger query covering the whole state of
California, roughly the longitude range -125° to -115° and the latitude range
32° to 42° from January 1, 2010 to January 1, 2020, or roughly a 10° x 10° x
3652 day slice.

To request this slice, the first thing we need to do is to map our query range
into the dataset indices. In this case, let’s say our dataset grid has the
dimension labels `x`, `y`, and `time`, and is indexed in degrees east from the
antimeridian (ranging 0-360), degrees north from the south pole (ranging
0-180), and in seconds since an epoch starting midnight January 1, 2000,
respectively.

To calculate our `x` index slice range, we need to determine how many degrees
east -125° to -115° is, which we can do by adding both values to 180°, giving
us the slice `[55:65]` (in Python notation). We have to scale this to our grid
though, which has 100 pixels per degree, so we end up with a `x` index slice of
[5_500:6_500]. The `y` slice is similar, but found by adding our values to 90°
and again scaling by 100, so there we get `[12_200:13_200]`. The `time`
dimension is a little tricker; for brevity we’ll skip ahead and say that slice
is `[87_672:175_320]` (this is a slice from 87,672 to 175,320 hours since our
January 1, 2000 epoch).

Note that these slice calculations happen today under the covers when using
Xarray or GDAL or whatever. No matter the tooling, when requesting chunks from
S3, the client must take a user query and resolve the matching chunks. Doing
this operation is not a requirement added by CCRP -- and we’d still leverage
existing implementations to handle this operation and to separate users from
these low-level concerns -- we just show it here to make the example CCRP
request below more understandable. With CCRP, clients would no longer have to
take the extra steps to resolve the specific chunk byte ranges covered by an
index slice and request each of them; responsibility to handle that concern
moves from the client to the CCRP API.

If this dataset is divided into 1° x 1° x 1 day chunks in an object store as an
unsharded Zarr (read: each chunk is a separate object), then, given our slice
ranges above, we end up needing to retrieve 10 x 10 x 3652 = 365,200 chunks,
each requiring an individual HTTP request. If the chunks were smaller to
accommodate even more granular access, say 0.25° x 0.25° x 6 hours, then we end
up having to make (4 x 4 x 4) x (10 x 10 x 3652) \= 23,372,800 requests!
Assuming a rather optimistic time-to-first-byte of only 15 ms (running compute
in region alongside the data, for example), we’d end up with almost 10 hours of
time spent in the download process not transferring any bytes just because we
have to make individual requests for each chunk.

Parallelism can definitely help here -- if we make ten requests at a time then
theoretically we would only end up waiting an hour for request overhead. Except
parallelism just masks the problem: the inefficiency is still there, the server
still must spend time servicing every individual request, and parallelism
forces a lot of complexity onto the client. Moreover, that the inefficiency
remains limits the ability of data providers to use even smaller chunks to
further mitigate the effects of query misalignment.

With CCRP we can make one HTTP request to get all chunks, regardless of the
chunk size. Though chunk size does impose one important constraint: because
CCRP doesn't support any means of rechunking, we do have to ensure our query
slices align to chunk boundaries. In this case, our query area and time aligns
to both the aforementioned 1° x 1° x 1 day and  0.25° x 0.25° x 6 hours chunk
grids, so we can use the same slices we initially calculated to make a CCRP
request:

```plaintext
GET https://ccrp.example.com/datasets/weather/data
    ?time[gte]=87672
    &time[lt]=175320
    &lon[gte]=5_500
    &lon[lt]=6_500
    &lat[gte]=12_200
    &lat[lt]=13_200
    &variable=temperature
```

Admittedly, this request is for a whole lot of data, and it is unlikely a user
would want to download all this with only one download stream. CCRP, as it is
proposed, also has support for cases where users want or need more control over
the download process, including progressive downloads to facilitate retries and
parallel download streams for large amounts of data, as this case.

### What could this look like with better tooling?

With current tooling the original S3 request might look like this:

```py
import xarray as xr

# Today - direct S3 access
ds = xr.open_dataset(
    's3://some_bucket/weather',
    engine='zarr',
)
array = ds['temperature'].sel(
    time=slice('2010-01-01', '2020-01-01'),
    lat=slice(122, 132),
    lon=slice(55, 65)
).values  # to realize the values into an array, the
          # tooling has to make a request for every chunk
```

Xarray and the lower-level tooling hides from the user that accessing the
`values` attribute of the temperature array has to make a separate request for
every chunk, as we’ve discussed.

How could this same operation look using CCRP?

```py
# Tomorrow - same interface, just using CCRP
ds = xr.open_dataset(
    'ccrp://example.com/datasets/weather',
    engine='zarr',
)
array = ds['temperature'].sel(
    time=slice('2020-01-01', '2020-02-01'),
    lat=slice(122, 132),
    lon=slice(55, 65)
).values  # the underlying tooling makes only one request
          # to realize the array (or a few for parallelism)
```

This looks exactly the same, aside from the dataset URL. And that’s the point:
CCRP is a low-level abstraction meant to make things easier for users, to plug
the leaks in the current object model abstraction. It should be transparent to
users.

## What happens next

I've drafted an [initial CCRP specification](https://ccrp.dev)
that defines:

* A RESTful API for listing, fetching metadata for, and querying datasets
* A small but flexible query syntax for both array and tabular data
* A two-phase protocol enabling parallel downloads
* Conformance classes for incremental implementation

But this is just the beginning. For CCRP to succeed, it needs help from a
number of stakeholders.

**Questions for users**

* Use case validation: Does this work with your access patterns?
* Data format and tool integrations: Is this effort targeting the right formats
  and tools?

**Questions for data producers**

* Chunking strategy examples: How would smaller chunks change your data?
* Access pattern documentation: What queries do your users need?
* Performance requirements: What latency is acceptable?

**Questions for cloud providers**

* Technical feasibility review: What would native implementation require?
* Performance projections: How much better could this be than a proxy?
* Integration possibilities: How would this fit with existing services?

**Other areas for community engagement**

* Specification feedback: What works? What doesn’t? What's missing?
* Proof-of-concept implementations: Can we demonstrate the concepts,
  performance gains, and quality of life improvements?
* Tooling integrations: Where do we need to add support for CCRP?

### An invitation

Again, **the [tyranny of the
chunk](https://element84.com/software-engineering/chunks-and-chunkability-tyranny-of-the-chunk/)
doesn't have to be permanent.** CCRP is an effort to fight the tyrrany of the
chunk.

Ideally this work is owned and driven forward by the community, not just me.
I’m just trying to kickstart it with some examples of what I’ve been thinking.
Everything is on the table, it’s all up for discussion. The spec certainly has
gaps, problems, and areas needing refinement. The examples are made up,
admittedly not great, and need to be revised with real values for both raster
and tabular datasets.  Actual proof-of-concept implementations are definitely
needed to better identify what works and what doesn’t, and to allow those
learnings to feedback into and inform the spec.

So again, if you work with large chunked datasets, I want to hear from you. If
you're building data infrastructure, I want your technical feedback. If you
work at a cloud provider, let's talk about what native implementation would
take. Or maybe you think this idea is flawed and can never work: awesome\!
Perhaps you hate the name: great\! I’d love to understand any and all concerns,
or, better, to know what you’d propose instead.

So take a look at the documentation and OpenAPI specification on [the ccrp.dev
site](https://ccrp.dev). The [FAQs page](https://ccrp.dev/docs/faqs) might
answer any questions that were not adequately addressed here. The [github
repo](https://github.com/ccrp-dev/ccrp) is a great place to open issues, ask
questions, or propose edits via PRs. We also have [a short
form](https://docs.google.com/forms/d/e/1FAIpQLSdV--Hl86XwBhMDSfNDBXDST4ZEBrZSXQ7hfuIl28NJWVOZag/viewform?usp=dialog)
we ask anyone interested in getting involved or staying up to date to fill out.
With enough interest we can make this a true community project, form a working
group, and even organize a sprint.

The future of cloud native can be whatever we want to make it. I believe the
object storage model is merely a local maximum for cloud native. Instead of
getting stuck here I want us to consider how to keep going up. CCRP is my idea
to address the problems I’ve been seeing, but I don’t think it is the only
answer, nor do I think the object storage model is the only local maximum. I
suspect there are others; what’s yours?

---

## Acknowledgements

This is already something of a community project with the number of people I’ve
talked to about this and who have graciously given the time and energy to
listen and provide feedback, to read and revise, or to generally just nod along
and help me realize I needed to do better communicating this idea. I’m sure I
am missing some people, but in no particular order:

* Julia Signell
* Matt Hanson
* Nathan Zimmerman
* Preston Hartzell
* Ian Cooke
* Sean Harkins
* Trevor Skaggs
* Sara Mack
* Seth Fitzsimmons
* The CNG Forum editorial board

Also thanks to [Element 84](https://element84.com) for supporting this work to
date.
