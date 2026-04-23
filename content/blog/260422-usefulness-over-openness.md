---
date: "2026-04-22T00:00:00-06:00"
title: "Beyond Open Data: Usefulness is a better measure of quality than openness"
tags: []
summary: "Beyond Open Data white paper thesis 1: Usefulness is a better measure of quality than openness."
author: "[Brianna R. (Pagán) Corremonte](https://www.linkedin.com/in/brianna-r-pag%C3%A1n-corremonte-phd-8a49a46b/) and  [Thomas Hervey](https://www.linkedin.com/in/t-hervey/)"
---

Why consider what lies “beyond” open data? We are currently in an era of exponential data growth and unprecedented accessibility, driven by rapid technological advancements and the rise of automated agents capable of consuming data at scale. While historical efforts to champion "open data" established admirable goals, the colloquial concept has become lackluster and antiquated. Making data broadly accessible, in theory, does not inherently make it *useful* in practice.

Historically, "openness" has often been treated as a binary checkbox, yet defined by varying degrees of adherence to a range of different criteria such as licensing. This is problematic because, in this example, a license alone does not dictate utility. We need a better way to represent the ultimate goal of open data: moving beyond a basic baseline of “openness” to evaluate data on a future-looking *spectrum of usefulness*.

## Defining the Usefulness Criteria Spectrum

To address this evaluation gap, our group set out to define what makes open data genuinely useful. We started by examining established openness frameworks, such as the 5-Star Linked Open Data and FAIR principles. Grounding our discussions in the real-world challenges users face in accessing and applying geospatial data, we debated how to objectively assess dataset quality. Our goal was to shift the evaluation from simply asking "how open is this?" to "how easily can this be used and reused for a specific purpose, or by a general audience with diverse needs?"

Through this workshopping process, we developed a report-card-style rubric. We settled on five core criteria for evaluating a dataset's usefulness, each rated on a 1-4 star scale. We then applied this rubric to various datasets. Ultimately, this distilled a core set of criteria that serves as a concrete reference guide for data providers. Below are the proposed criteria:

* **License**  
  A license is the legal permission to use and reuse data or a software product. It is traditionally the primary criterion for determining whether the data is open. To minimize the effort required for users to understand and comply with license terms, data providers should use standardized open licenses rather than custom ones. Importantly, however, just because data has a more open license (i.e., a license with fewer use and reuse restrictions) doesn’t mean it's useful or easy to reuse.

* **Cost**  
  Open and free of cost are not synonymous. Open data can incur associated (financial) costs that vary significantly. Importantly, once data is made freely available, it's hard to restrict its usage.

* **Burden**  
  Burden measures how long it would take a reasonably skilled user to access and start using the data of interest. Importantly, many datasets could be considered highly “open” under an open data framework (e.g., FAIR principles), yet remain burdensome to access, use, and reuse. This may be due to anti-patterned user interfaces, convoluted search/information retrieval systems, or nested, siloed data management systems that make accessing the data difficult.  
  	Furthermore, some organizations will email a requested dataset, which can lead to long wait times. In other cases, some organizations use niche data formats that are supported by only a few software programs. Interoperability, which we define as the ability of your data to work with other systems (proprietary or not), can add a significant burden and contribute to the overall burden measurement.

* **Access**  
  Similar to the “Accessible” definitions in the FAIR principles framework, access is the degree to which all audiences can use data. However, in practice, data can be available under an open license yet be difficult or impossible to access. For example, putting open data behind a registration or paywall reduces access. Additionally, if the data is in a proprietary format that requires downloading specialized software, access is further limited. If the data can't be directly shared, you’re limiting downstream access for other users. Importantly, we had initially listed searchability as a separate criterion, but decided to lump it in with Access for simplicity.

* **Provenance**  
  How can you trust your data? What is its lineage? Provenance as a criterion is the completeness of a data lineage. Data can be open and either of very poor quality or poor provenance. For example, consider malicious edits to Wikipedia articles that introduce false information. It's open, but being able to track the provenance and trustworthiness of the data is key to actually using it openly.  
  	The key to strong data provenance is to ensure you can trace the data back to its source and see any manipulations that occurred along the way. Importantly, AI can generate trustworthy-looking data, but quality typically falls apart when you try to trace back to the original data source.

* ***Add your own***  
  The previous criteria were identified as being most common and impactful to the usefulness of *any* data. However, data’s usefulness ultimately depends on the guiding applications or desired outcome. For example, for medical applications, data compliance may be a primary criterion. Therefore, data providers should convene with experts in their field to help determine which, if any, additional criteria are most important for promoting useful and open data.

During the definition process, the following additional criteria were considered but ultimately removed or lumped into the criteria previously stated:

* Interoperability  
* Intent  
* Data domain coverage and granularity  
* Data structure  
* Integration points (APIs)  
* Documentation and user support  
* Compliance  
* Schema completeness 

## Visualizing the Spectrum

To quantify the relative usefulness grade of open data or an open dataset, we create a scorecard with five primary criteria and assign each a score of 1-4 stars. Users can customize it by adding data-specific criteria tailored to their needs. The figures below show how we defined the star scores (Figure 1\) and an example scorecard for FEMA’s open data (Figure 2). We fully recognize that these evaluations were subjective and that collaboration with a larger group should necessarily evolve and harden the criteria spectrum.

<table style="border-collapse: collapse; width: 100%; font-size: 14px;">
<thead>
<tr style="border-bottom: 2px solid #000;">
<th style="text-align: left; padding: 8px; border-right: 1px solid #ddd;">Criteria</th>
<th style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★</th>
<th style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★★</th>
<th style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★★★</th>
<th style="text-align: center; padding: 8px; font-size: 1.5em;">★★★★</th>
</tr>
</thead>
<tbody>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">License</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Custom license (need a lawyer)</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Open license with burdensome terms (copyleft, share alike) (ODBL)</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Commonly used open license with reasonable requirements (such as attribution) (CC4.0 versions)</td>
<td style="padding: 8px;">Public Open Domain, no restrictions. (CC0)</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Cost</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Pricing is too high to justify</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Nominal costs</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Free with other indirect costs</td>
<td style="padding: 8px;">Free</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Burden (includes Interoperability)</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">5+ hours</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">2-5 hours</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">1-2 hours</td>
<td style="padding: 8px;">Less than an hour</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Accessibility</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Custom format, clunky website, no APIs</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Custom format, but the website or platform is functional</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Standard open format, decent website with APIs</td>
<td style="padding: 8px;">Standard open format, performant and easy website, APIs available.</td>
</tr>
<tr>
<td style="padding: 8px; border-right: 1px solid #ddd;">Provenance</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Unknown source and methods</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">No documentation, but it has metadata</td>
<td style="padding: 8px; border-right: 1px solid #ddd;">Some documentation and metadata</td>
<td style="padding: 8px;">Fully documented with metadata</td>
</tr>
</tbody>
</table>

**Figure 1\.** Definitions of the criteria’s four-star scores.

<table style="border-collapse: collapse; width: 100%; font-size: 14px;">
<thead>
<tr style="border-bottom: 2px solid #000;">
<th style="text-align: left; padding: 8px; border-right: 1px solid #ddd;">Criteria</th>
<th style="text-align: center; padding: 8px; border-right: 1px solid #ddd;">Score</th>
<th style="text-align: left; padding: 8px;">Additional Details</th>
</tr>
</thead>
<tbody>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">License</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★★★☆</td>
<td style="padding: 8px;">Public domain with several terms and conditions: <a href="https://www.fema.gov/about/openfema/terms-conditions">https://www.fema.gov/about/openfema/terms-conditions</a></td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Cost</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★★★★</td>
<td style="padding: 8px;">No cost</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Burden</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★☆☆☆</td>
<td style="padding: 8px;">Lots of 404s, dead ends, and it's very hard to search for data.</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Accessibility</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★☆☆☆</td>
<td style="padding: 8px;">No APIs for NFHL (some exist for other FEMA info, but very fragile)</td>
</tr>
<tr style="border-bottom: 1px solid #ddd;">
<td style="padding: 8px; border-right: 1px solid #ddd;">Provenance</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd; font-size: 1.5em;">★★★☆</td>
<td style="padding: 8px;">Some documentation was available, and metadata exists.</td>
</tr>
<tr>
<td style="padding: 8px; border-right: 1px solid #ddd;">Total</td>
<td style="text-align: center; padding: 8px; border-right: 1px solid #ddd;">12/20</td>
<td style="padding: 8px;">The dataset scores 60% useful based on our criteria.</td>
</tr>
</tbody>
</table>

**Figure 2\.** An example of a scorecard for FEMA open data derived by a group participant.

The next two Beyond Open Data blogs will come out in the coming weeks. You can read the full white paper at https://cloudnativegeo.org/beyond-open-data-white-paper.pdf. 