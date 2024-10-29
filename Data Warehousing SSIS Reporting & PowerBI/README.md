# Data Warehousing and Visualization Assignment

## Overview

The focus of this assignment is to analyze the New York City Bike Share system using a dataset that contains trip information from January 2015 to June 2017. The analysis aims to uncover insights that can help the City Bike Company improve their service and marketing strategies.

## Business Goals

The primary objective of this assignment is to answer specific questions posed by the City Bike Company regarding their bike-sharing service. The company is interested in understanding user patterns and demographics to make informed decisions about resource allocation and marketing strategies. The key questions include:

1. **Peak Usage Times:** When are the busiest times for bike usage in the system?
2. **Common Ride Durations:** What is the most frequent duration of rides?
3. **Popular Stations:** Which bike stations are the most frequently used?
4. **Rider Demographics:** What are the age and gender distributions of the riders?

By analyzing this data, the City Bike Company hopes to determine if additional bikes are needed at specific stations or during particular time periods. Furthermore, understanding the demographics of their users will aid in tailoring marketing efforts to attract different age groups.

## Dataset Description

The dataset used for this analysis was obtained from Kaggle and contains 735,502 anonymized trip records. Each entry in the dataset provides detailed information about the bike rides, including:

- **Trip Duration:** Length of each trip in seconds.
- **Start and Stop Dates/Times:** Timestamps indicating when a trip begins and ends.
- **Station Information:** Names, IDs, and geographical coordinates of start and end stations.
- **Bike ID:** Unique identifier for each bike used in the system.
- **User Type:** Classification of users into customers (24-hour pass or single ride users) and subscribers (annual members).
- **Gender:** Demographic information encoded as 0 (unknown), 1 (male), or 2 (female).
- **Year of Birth:** Used to calculate the rider's age.

## Project Structure

The project includes the following sections:

1. **Business Goals and Dataset Description:** Overview of the project's objectives and dataset.
2. **Data Cleaning & Relational Schema:** Details on how the data was prepared for analysis and the structure of the relational database.
3. **Importing Data and Building the Database:** Steps taken to import the dataset into a relational database and the creation of necessary tables.
4. **Deploying the SSIS Package:** Information on how the SQL Server Integration Services (SSIS) package was deployed to facilitate data processing.
5. **Defining the Data Cube:** Outline of the multidimensional data structure used for analysis.
6. **Exporting Cube Data to Excel:** Methodology for exporting data from the data cube for reporting purposes.
7. **Reporting in SSRS:** Overview of the SQL Server Reporting Services (SSRS) reports generated from the analysis.
8. **Power BI:** Visualizations created using Power BI to present the findings.
9. **PowerPoint Presentation:** Final presentation summarizing the analysis and results.

## Conclusion

Through this assignment, we aim to provide actionable insights to the City Bike Company that can inform their decisions regarding bike allocation and marketing strategies. The findings will be presented in a clear and accessible format, allowing stakeholders to understand the current usage patterns and demographics of the bike-sharing service.
