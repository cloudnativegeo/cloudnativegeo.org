+++
date = "2024-03-11T01:00:00-01:00"
title = "Q&A with Qiusheng Wu on Open-Source Tools, YouTube Success, and Cloud-Native Geo Innovation"
tags = [ ""
]
summary = "Dr. Qiusheng Wu, Associate Professor at the University of Tennessee, blends research with open-source software development and freely shares his knowledge on YouTube through hands-on tutorials. In this Q&A, we find out what drives this dedication."
+++

{{< img src="images/20240311-qiusheng.jpg" alt="Dr. Qiusheng Wu" caption="Dr. Qiusheng Wu, Associate Professor at the University of Tennessee." >}}

### You are behind two game-changing tools: leafmap, a user-friendly Python library for interactive mapping and geospatial exploration, and geemap, a Python package for seamlessly integrating Earth Engine data analysis and visualization. What motivates you to invest your time and expertise in creating free, open-source tools?

My primary motivation stems from a passion for harnessing the power of geospatial technologies to address environmental challenges. In the Spring of 2020, while teaching Earth Engine at the University of Tennessee, I encountered a significant obstacle. The Earth Engine Python API documentation was very limited, making it difficult for my students to effectively visualize and explore Earth Engine data interactively. This challenge inspired me to create [geemap](https://geemap.org) to bridge this gap. Since its initial release on GitHub in March 2020, I have dedicated considerable time and effort to fixing bugs and adding new features to the package. I was thrilled to see that geemap was adopted by Google and included in the Earth Engine documentation in October 2023.

The creation of [leafmap](https://leafmap.org) was a response to the need for interactive visualization of geospatial data beyond Earth Engine. Leafmap allows users to visualize geospatial data across multiple cloud providers, such as Microsoft Planetary Computer and AWS, with minimal Python coding. My goal is to lower the barriers to entry, empowering students, researchers, and developers worldwide to leverage the immense potential of these powerful geospatial technologies and cloud computing. The invaluable feedback and feature requests from the community play a crucial role in shaping these tools' ongoing development and evolution.

### With close to 30,000 subscribers, your [YouTube channel](https://www.youtube.com/@giswqs) is quite popular with learners worldwide. Can you share some of the most rewarding experiences you’ve had interacting with individuals who benefitted from your resources? Did their stories shape your approach to teaching or the topics you cover? 

One of the most rewarding things is connecting with people who benefit from my videos all over the world. For instance, I received a heartwarming message from a learner who shared how my work has transformed their research and teaching, ultimately helping them secure a tenure-track position at a university. Knowing that my resources played a significant role in their success is incredibly fulfilling. Hearing about students applying the techniques in their thesis work, researchers using them to make new discoveries, or developers using them to build geospatial solutions for customers fuels my desire to create even better, more accessible tools and tutorials. I also welcome bug reports or feature requests on GitHub. Their feedback and requests guide the content I develop and ensure it's truly meeting the needs of the community.

### As someone who has used Source Cooperative to create [new data products](https://beta.source.coop/giswqs/), we’d love to hear your feedback. How has your experience with Source been? Did it influence your approach to geospatial data analysis or contribute to your environmental research, and if so, how?

One of the standout features is the ability to publish and share geospatial data with the community using the AWS CLI. This eliminates the need to set up and manage an AWS S3 bucket and access permissions on my own, saving me valuable time and effort. In addition, its intuitive file browser-like interface makes finding the right data within the repository a breeze.

Based on my experience, I highly recommend Source Cooperative to anyone interested in making geospatial data more accessible. The platform's features and capabilities have certainly influenced my approach to geospatial data analysis, enabling me to work more effectively and efficiently. Additionally, Source Cooperative has contributed to my research by providing a reliable and convenient platform for data storage and sharing. I highly encourage anyone in the geospatial community to give Source Cooperative a try. It's a valuable tool that has the potential to greatly enhance your geospatial endeavors.

### Your datasets are structured in cloud-native geospatial formats like GeoParquet. Can you elaborate on how cloud-native formats have impacted your workflow and research in terms of efficiency, collaboration, or scalability? 

Source Cooperative supports cloud-native geospatial data formats like Cloud Optimized GeoTIFF and GeoParquet. This means that the data stored on Source Cooperative can be seamlessly consumed by popular open-source libraries such as leafmap and DuckDB. In the past, running even simple summary statistics on large vector datasets would take me hours. However, with DuckDB and the GeoParquet files on Source Cooperative, I can now perform analysis that used to take hours in a matter of seconds. It's a significant improvement in efficiency and productivity. 

I was thrilled to integrate these advancements into my Spatial Data Management course at the University of Tennessee, where students experienced these benefits firsthand. Open-access course materials are available [here](https://geog-414.gishub.org/book/duckdb/01_duckdb_intro.html). 

### Can you share any hard lessons you encountered along the way that shaped your approach to your work or the impact you strive to make?

Every journey has its challenges, and my own path in the open-source geospatial field has been no exception. Along the way, I've encountered many obstacles that have taught me valuable lessons and profoundly influenced my work and the impact I strive to make.

One of the hard lessons I've learned is the importance of embracing failure and setbacks as opportunities for growth. I've experienced moments where I dedicated hours or even days to implementing features in my open-source packages, only to face setbacks. These experiences have taught me that failure is not a reflection of my abilities, but rather a chance to learn, adapt, and improve. 

Collaboration and community have also played a pivotal role in shaping my approach to work. I've been fortunate to connect with talented open-source package developers from around the world, exchanging insights, collaborating on projects, and collectively pushing the boundaries of what we can achieve. 

Lastly, I have learned the importance of adaptability and staying current with technological advancements. The geospatial field is constantly evolving, with new tools, techniques, and data sources emerging regularly. To stay relevant and make a meaningful impact, I have had to embrace a mindset of continuous learning and adaptability. This involves staying updated with the latest trends and being open to exploring new technologies and tools that can potentially be integrated into my open-source packages.

### What do you think we as a community could be doing to help accelerate the adoption of cloud-native data?

As a community, there are several actions we can take to accelerate the adoption of cloud-native data:

- Education and Awareness: Increasing awareness about the benefits of cloud-native data is crucial. We can organize training workshops, webinars, and conferences to educate individuals and organizations about the advantages of cloud-native data storage, processing, and analysis. Real-world use cases and success stories can inspire adoption.
- Improved Documentation and Tutorials: Encouraging developers and maintainers of open-source geospatial packages to create tutorials and update documentation that highlights cloud-native formats can drive adoption. The [Cloud-Optimized Geospatial Formats Guide](https://guide.cloudnativegeo.org) is a valuable resource for understanding various cloud-native formats for geospatial data. 
- Foster Collaboration: Creating a collaborative environment where knowledge sharing is encouraged and newcomers feel comfortable seeking help can accelerate adoption. Establishing forums, discussion groups, and open-source communities dedicated to cloud-native data can facilitate collaboration and provide support. The [Cloud-Native Geospatial Foundation Slack channel](https://cloudnativegeo.slack.com) is a great example. 

By focusing on education, documentation, and collaboration, we can collectively drive the adoption of cloud-native data. Together, we can harness the power of cloud technologies and unlock new possibilities in the geospatial domain.

### Books, articles, podcasts, or even movies - what media has influenced your career and shaped your perspective on geospatial science and its role in environmental understanding?

As an open-source developer and educator, I've found various media forms to be influential in shaping my perspective on geospatial science and its role in environmental understanding.

- Open-source package documentation: The documentation of open-source packages like ipyleaflet, localtileserver, geopandas, rasterio, and xarray, has been invaluable in learning about geospatial tools and libraries. These resources offer practical guidance and examples for incorporating geospatial analysis into my work.

- Podcasts: [MapScaping](https://mapscaping.com) and [MindsBehindMaps](https://www.mindsbehindmaps.com) have been instrumental in broadening my perspective. These podcasts feature interviews with experts in the field, discussing topics ranging from remote sensing to artificial intelligence in geospatial science.

- Online courses: Online courses are an excellent resource for learning geospatial concepts and technical skills, and several platforms offer valuable options. One notable platform is [SpatialThoughts](https://spatialthoughts.com), which provides a range of geospatial courses that are highly beneficial for learners. I have personally found these courses to be incredibly valuable in improving my technical skills. I highly recommend exploring the courses offered by SpatialThoughts and taking advantage of the opportunity to learn from their comprehensive and well-designed curriculum. Whether you are a beginner or an experienced professional, these courses can help deepen your understanding of geospatial concepts and advance your skills in the field. 
