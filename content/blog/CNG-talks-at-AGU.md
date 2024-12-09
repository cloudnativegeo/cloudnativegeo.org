---
date: "2024-12-09T1:00:01-04:00"
title: "Must-View Talks and Posters on Cloud-Native Geospatial at AGU 2024"
tags: [ ""
]
summary: "This blog post highlights some key talks and posters at AGU 24 you won't want to miss."
---
The [AGU Fall Meeting 2024](https://www.agu.org/annual-meeting), the largest gathering for Earth and space science, starts this morning, Monday December 9-13 in Washington, DC. This year, there are many papers on cloud-native geospatial technologies by CNG members and other experts. This blog post highlights some key talks and posters you won't want to miss.

### Monday Dec 9

**Dynamic Tiling for Earth Data Visualization:** This talk explores dynamic tiling, a method for generating map tiles on-the-fly, allowing for real-time modifications and eliminating the need for constant updates. Presented by . [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1624796)

### Wednesday Dec 11

**VirtualiZarr - Create Virtual Zarr Stores Using Xarray Syntax:** This paper presents VirtualiZarr, a tool that allows accessing old file formats (like netCDF) as if they were stored in cloud-optimized formats (like Zarr). The authors will demonstrate using the Worthy Ocean Alkalinity Enhancement Efficiency Map dataset, which consists of ~40TB of data spread across ~500,000 netCDF files. Presented by Thomas Nicholas from Worthy, LLC.
 [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1725217)

**Supporting Open Science with the CF Metadata Conventions for NetCDF:** This talk highlights the Climate and Forecast (CF) conventions, a critical standard for sharing and processing Earth science data in netCDF format and in Zarr/GeoZarr. Presented by Ethan Davis from NSF Unidata. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1771431)

### Thursday Dec 12

**Integrating Zarr with netCDF: Advancing Cloud-Native Scientific Data Interoperability with ncZar:** This paper explores the integration of ncZarr with the netCDF ecosystem. The authors will discuss the current state of this effort, and what can be expected in upcoming netCDF releases. They will outline use cases, and discuss, in practical terms, how to use ncZarr as part of a cloud-based workflow which assumes the involvement of the netCDF data model. Presented by Ward Fisher from the University Corporation for Atmospheric Research.  [Learn more](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1701488)

**Transforming NASA Earth Observation Data With POWER:** This paper explores NASA's Prediction of Worldwide Energy Resources (POWER) project and its utilization of cloud-optimized formats like Zarr for delivering Earth observation data. Presented by Nikhil Aluru from ORCID, Inc, NASA Langley Research Center. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1566769)

**A new sub-chunking strategy for fast netCDF-4 access in local, remote and cloud infrastructures:** This paper presents a new strategy for faster access to netCDF-4 data in various environments. A comparison with the cloud-oriented formats Zarr and NCZarr is conducted. Presented by Pierre-Marie Brunet from Centre National d'Études Spatiales. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1546229)

**Seamless Arrays: A Full Stack, Cloud-Native Architecture for Fast, Scalable Data Access:** This talk will introduce a new approach to accessing Earth systems data called “Seamless Arrays,” which is the ability to easily query a data cube across both spatial and temporal dimensions with consistent low latency. The author will showcase their prototype implementation of Seamless arrays, inspired by cloud-native database systems like Snowflake, consisting of two primary components - a Zarr-based schema and an API layer. Presented by Joseph Hamman from Earthmover. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1645428)

**Cubed: Bounded-Memory Serverless Array Processing in Xarray** Cubed is a framework for processing large arrays, designed to be memory-efficient and scalable. It uses Zarr as a persistent storage layer and can run on various cloud platforms. The authors will demonstrate running Cubed in the cloud for various common geoscience analytics workloads. Presented by Tom White from Tom White Consulting. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1619114)

### Friday Dec 13

**Pangeo-ESGF CMIP6 Zarr Data 2.0 - Streaming Access to CMIP6 data in the cloud that rocks!:** This talk will introduce the new data, describe the ingestion architecture, reflect on both successes and challenges of this approach, and elaborate on future directions for Coupled Model Intercomparison Project (CMIP6+ and CMIP7). You will be convinced to use the cloud data for research! Presented by Julius Johannes Marian Busecke from LDEO/Columbia University.
[Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1741309)

**Leveraging GPU Acceleration for High-Resolution 3D Visualization of Earth Observation Data:** This paper explores a workflow for leveraging GPUs to visualize Earth observation data in 3D, enabling rapid rendering and enhanced analysis capabilities. Presented by Navaneeth Rangaswamy Selvaraj from the University of Alabama in Huntsville. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1620781)

**Earth Science Data Access and Discovery and the Cloud: Past, Present, and Future II:** This poster explores the evolution of cloud computing for Earth science data access and discovery, along with best practices for maximizing cloud investment. Presented by Douglas J Newman from NASA Goddard Space Flight Center. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Session/240419)

**How can we make cloud computing actually accessible to all scientists?:** This talk explores the barriers hindering wider adoption of cloud computing in scientific research and proposes solutions for overcoming them. Presented by Ryan Abernathey from Earthmover. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Person/74375)

**High-Performance Access to Archival Data Stored in HDF4 and HDF5 on Cloud Object Stores Without Reformatting the Files:** This paper explores a NASA-sponsored technology, DMR++, which is designed to enhance access to large, historical datasets stored in older formats like HDF4 and HDF5. By leveraging cloud object stores, DMR++ enables efficient data access without the need for time-consuming reformatting. This technology optimizes data storage and access, particularly for massive datasets, and can even store calculated values directly within the data structure, eliminating the need for specialized software tools. Presented by James H R Gallagher from OPeNDAP, Inc. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1653592)

### iPoster Gallery 
TensorLakeHouse: A High-Performance, Open-Source Platform for Accelerated Geospatial Data Management with Hierarchical Statistical Indices This online poster introduces TensorLakeHouse, an open-source platform designed for high-performance geospatial data management and processing. Presenting author: Naomi Simumba from IBM Research. [Learn more.](https://agu.confex.com/agu/agu24/meetingapp.cgi/Paper/1673134)

This list provides a starting point for exploring the exciting world of cloud-native geospatial at AGU 2024. Our blog is open source. If we are missing any talks or posters, you can suggest edits on GitHub.  

Remember to check the conference website for the latest schedule and additional details. Happy exploring!
