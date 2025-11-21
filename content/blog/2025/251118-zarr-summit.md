---
date: 2025-11-18T08:00:00-00:00
title: "2025 Zarr Summit Recap"
author: "[Max Jones](https://www.linkedin.com/in/maxrjones/), [Davis Bennett](https://www.linkedin.com/in/davis-bennett-62922126a/), [Joe Hamman](https://www.linkedin.com/in/jhamman/), [Michelle Roby](https://www.linkedin.com/in/the-michelle-roby/)"
author_title: "Zarr Summit Organizing Team"
summary: "The first Zarr Summit in Rome brought together developers and adopters from around the world, resulting in significant technical prototypes, a new conventions framework, lasting cross-community connections, and overwhelming enthusiasm for future community gatherings."

---

The Zarr community convened in Rome, Italy, on October 13-17, 2025, for the first-ever Zarr Summit\! It was an incredible experience.

During the first three days, Zarr developers collaborated on crucial improvements to the Zarr ecosystem. We prototyped long-requested features, bootstrapped a framework for flourishing community-driven metadata conventions, and dramatically improved cross-language implementation parity.

During the final two days, we welcomed adopters from diverse organizations to meet with developers to discuss best practices and common roadblocks, exchange ideas, and build connections across the Zarr Community.

{{< img src="images/251118-zarr-summit1.jpg" caption="Zarr Summit adopter days group photo">}}

And most importantly, we had a blast\!

## Takeaways

### Zarr is taking off 🚀

We knew Zarr was getting big even before the event; [ESA's adoption of Zarr for Sentinel products](https://zarr.eopf.copernicus.eu/) was a key inspiration for the summit. Still, we were blown away by the depth and breadth of Zarr adoption worldwide across all sorts of institutions. Large communities and data providers are embracing Zarr, and many more people are actively using Zarr V3 in production. The cross-domain nature of our community continues to be one of our greatest strengths.

### We really needed an in-person gathering, and it paid off 🎉

One of my favorite quotes from the summit was that we "accomplished 3 years of work during 3 days". People loved the event because it brought together folks who never before had the chance to meet in person, provided an amazing space to share knowledge and form meaningful connections, and offered a good balance of structured sessions and unstructured time for making real progress, real fast. The feedback was overwhelmingly positive, with post-event survey respondents giving the event 4.8/5 stars and every single respondent expressing interest in another Zarr event. 

### Our work isn't done 💪

We need to make the summit prototypes production-ready, provide continuous connection points between Zarr developers and adopters, and keep an eye on future needs. While much of the work can be done asynchronously, we should balance online collaboration with in-person and hybrid events to maintain momentum on the project.

## Outcomes

We made truly incredible progress in a very short time. Here are some highlights ✨

### Technical features

The developer days included group discussions, breakout groups, and unstructured collaboration time. A few outcomes from the developer days include:

* [Zarr conventions and metadata](https://github.com/zarr-conventions)—this was the most frequently mentioned valuable outcome. We bootstrapped the [conventions framework](https://github.com/zarr-conventions/zarr-conventions-spec) to enable community-driven metadata standards to flourish across different domains and use cases. We'll post a more detailed overview of this framework on [Zarr's blog](https://zarr.dev/blog/) in the near future.  
* Sharding improvements \- Multiple teams worked on [sharding](https://zarr.dev/zeps/accepted/ZEP0002.html), making significant progress on implementation parity across languages and resolving long-standing questions about performance optimization.  
* Variable chunk grids \- Developers built both an [extension](https://github.com/zarr-developers/zarr-extensions/pull/25) and working prototypes of variable chunk grids in multiple languages\! Check out the draft PRs for [Python](https://github.com/zarr-developers/zarr-python/pull/3534) and [Rust](https://github.com/zarrs/zarrs/pull/284).  
* Sparse array support \- Participants added support for [specifying input and output buffers for codecs in Zarr Python](https://github.com/zarr-developers/zarr-python/pull/3529), in support of [sparse array functionality](https://www.google.com/url?q=https://github.com/keewis/zarr-sparse&sa=D&source=docs&ust=1763155013342990&usg=AOvVaw3mrr8j3P6M0pWE14OfAed-).  
* Optimizing storage and performance through codecs \- Multiple groups worked on adding new functionality to Zarr via codecs, such as the [ability to "turn off" compression when it’s ineffective](https://github.com/zarr-developers/zarr-extensions/pull/27) and to [use Zarr with TIFF (or similar) file headers](https://github.com/zarr-developers/zarr-extensions/pull/36).  
* Arrow in Zarr \- Participants developed a [detailed design document](https://www.google.com/url?q=https://hackmd.io/qCjqg9HBRiGYKBRHphaozQ&sa=D&source=docs&ust=1762303053582926&usg=AOvVaw2oEeJ0LIrmGDgZeIzVWh6L) for Arrow in Zarr that enables efficient storage of ragged arrays, nested structures, and variable-length data types.  
* Linked Arrays (multiscales, chunk manifests, and more) \- Participants brainstormed the use-cases for linked arrays, such as multiscales, masked arrays, multiply-chunked arrays, and virtual arrays, and outlined different implementation strategies. This nascent idea has the potential to profoundly expand Zarr's impact across numerous disciplines.  
* Virtual Zarr \- We brainstormed the future of Virtual Zarr, including how to support the approach [Kerchunk](https://github.com/fsspec/kerchunk) pioneered and [Virtualizarr](https://github.com/zarr-developers/virtualizarr) popularized within a Zarr-native structure.  
* Cross-language conformance \- We improved compatibility testing to ensure feature parity across Python, Rust, Julia, and other implementations.

{{< img src="images/251118-zarr-summit2.jpg" caption="Zarr Summit developer days collaboration and socialization">}}

### Learning and inspiration

We had an incredible assortment of speakers, workshops, and breakout groups at the Zarr adopter days.

#### Keynotes

* Davis Bennett [clarified what Zarr is (and isn’t) and gave participants the understanding necessary to use Zarr to its full potential](https://docs.google.com/presentation/d/1QB-EKo1qFqIreqehowBmz5kFJsUQCgYxprgrVabF35Y/edit?usp=sharing).  
* Ryan Abernathey inspired the room by highlighting what has made Zarr special and by presenting a wish list for Zarr’s future.

#### Tools and infrastructure

* Joe Hamman showed us [how to make Zarr "go zoom"](https://docs.google.com/presentation/d/1Ejfx91jBcFA1_ewjiY2XTxNHzRkVmpGz2Fa4O2HWlbU/edit?usp=sharing) with performance optimization techniques.  
* Sebastian Galkin introduced [Icechunk](https://icechunk.io/en/stable/) for [putting Zarr data into production with transactional guarantees](https://github.com/paraseba/zarr-summit-2025-presentation/blob/1403cac4550c140b8daf1c9796f897786fb7f2a6/talk.pdf?raw=true).  
* Tom Nicholas demonstrated VirtualiZarr as a bridge from archival file formats to Zarr.  
* Lachlan Deakin showcased the [Rust ecosystem's Zarr capabilities](https://zarrs.dev/slides/zarr_summit_presentation_2025_10/#/1).

#### Real-world applications

* Norman Rzepka shared how [Zarr enables petascale neurobiology research](https://docs.google.com/presentation/d/1IpyW6sq0tE5X1d4Xlm2rjDvePpjiTx61Jwmv6193Rrk/edit?usp=sharing).  
* Alessandro Amici presented the [Earth Data Hub](https://platform.destine.eu/services/service/earth-data-hub/)'s use of Xarray and Zarr for massive climate datasets.  
* Tobias Ferreira provided a fantastic overview and [showcase](https://github.com/NOC-OI/zarr-vis) of browser-based Zarr Visualization.  
* [Tina Odaka highlighted](https://docs.google.com/presentation/d/1ESXFU1bQ5UylHOJG7tmzb8fAvXoabXi7MuuML421Dxc/edit?slide=id.g38624ceeb22_0_2630#slide=id.g38624ceeb22_0_2630) how [Grid4Earth](https://eopf-dggs.github.io/) unifies DGGS and Zarr for Scalable, Interoperable Earth Data for DestinE and Copernicus Sentinel Data.  
* Emmanuel Mathot detailed recent improvements to the EOPF Explorer project that dynamically visualize Copernicus Sentinel Data.  
* Exciting lightning talks on the STAC sprint outcomes, [Browzarr](https://browzarr.io/), VirtualiZarr in Oceanography, [in-browser EO data visualization and analytics](https://drive.google.com/file/d/12wDlzuihlT4Gf9v_E5VJ78gXERebYcjw/view?usp=sharing) with the [SpongeCity Toolbox](https://spongecity.zgis.at/), [Cubed](https://docs.google.com/presentation/d/1y-k-Yt3TpDW6wzzRkbzIlU-qqbeQhSHTjj3jQw5ilwo/edit?slide=id.p#slide=id.p), EOPF, Sparse, and the KM scale global hackathon.

#### Hands-on learning

Workshops covered practical topics, including [Icechunk deep dives](https://github.com/earth-mover/zarr-summit-2025), [VirtualiZarr for archival formats](https://github.com/developmentseed/zarr-summit-virtualizarr-workshop), performance optimization (including for [rechunking](https://docs.google.com/presentation/d/1ZgdIaZ04OModKM9bzor6gkdMM-9o2xzCzgAgMydSBsI/edit?slide=id.p#slide=id.p) operations), and choosing whether Zarr is right for specific use cases. Breakout sessions and birds-of-a-feather gatherings allowed people to dive deep into specialized topics: machine learning applications, visualization strategies, microscopy workflows, and language-specific implementations in Python, Rust, Julia, and R.

### Lasting connections

The summit brought together a truly global community. Participants traveled from Liverpool, Oslo, São Paulo, Hamburg, Bari, Cardiff, Ottawa, and many other cities across Europe, North America, South America, Africa, and Australia. The cross-disciplinary breadth of participants made the summit truly special. Collocating with the STAC Sprint in Rome also enabled unique cross-community collaboration—our joint aperitivo and Friday's shared sessions brought together Zarr and STAC developers in ways that wouldn't have been possible otherwise. The face-to-face interactions throughout the event built trust, accelerated problem-solving, and created relationships that will continue to benefit the Zarr ecosystem long after the summit ended.

{{< img src="images/251118-zarr-summit3.jpg" caption="Zarr Summit adopter days presentations, breakout groups, and sunset aperitivo">}}

## The future

This event generated tremendous momentum for development and adoption. Looking ahead, we see several priorities:

### Finalizing prototypes

The many prototypes and proof-of-concepts developed during the summit need to be polished, tested, and released as production-ready features. This includes the conventions framework, codec implementations, and improvements to cross-language compatibility.

### Documentation and accessibility

Making it easier for newcomers to get started with Zarr and understand best practices remains a priority. The zarr.dev website needs improvements, and we need better examples of large, operational Zarr stores for others to learn from.

### Growing the community

With 100% of participants expressing interest in future Zarr events, there's clear demand for more regular gatherings. We have received extremely helpful feedback from participants and would be glad to support anyone looking to build upon the Zarr Summit.

## Thank you

We're so grateful to [The Navigation Fund](https://www.navigation.org/) for supporting the Zarr Summit; without their support, the event would not have been possible.

We greatly appreciate [GeoBeyond](http://www.geobeyond.it/) and [B-Open](https://www.bopen.eu/)'s gracious sponsorship of the Zarr Summit.

The institutional support from [Cloud-Native Geospatial](https://cloudnativegeo.org/) (CNG), [Development Seed](https://developmentseed.org/), and [Earthmover](https://earthmover.io/) also made this event possible—thank you for your commitment to open source and open science\!

Most importantly, thank you to everyone who participated for bringing so much enthusiasm, knowledge, and collaborative spirit to the event. Your energy and commitment to the Zarr ecosystem made this summit truly special. We're excited to continue building together\!

## Support Zarr’s future

We want to do another summit in 2026\. Get in touch if your organization is in a position to support this\! You can contact [Max Jones](mailto:max@developmentseed.org) (2025 Summit Leader), the [Zarr Steering Council](mailto:zarr-steering-council@googlegroups.com), or [donate directly](https://numfocus.org/donate-to-zarr) through Zarr’s Fiscal Sponsor, [NumFOCUS](https://numfocus.org/).

