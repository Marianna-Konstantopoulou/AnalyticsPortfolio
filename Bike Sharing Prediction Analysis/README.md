# Bike Sharing Prediction Analysis

This repository contains the analysis and predictive modeling of bike rental counts using a bike-sharing dataset. The project aims to understand the factors influencing bike rentals and to develop a model that can accurately predict hourly bike rental counts based on various environmental and seasonal settings.

## Contents

- **Data**: Contains the training and test datasets.
- **Analysis**: Includes exploratory data analysis (EDA) and visualizations.
- **Modeling**: Features model implementation and evaluation.
- **Report**: Summarizes findings and results.

## Background

Bike-sharing systems are a modern evolution of traditional bike rentals, allowing users to rent and return bikes at various locations easily. With over 500 programs globally, these systems have a significant impact on urban transportation, environmental sustainability, and public health. 

The dataset used in this project comprises hourly bike rental logs, which include important features such as:

- Date and time of rental
- Seasonal indicators
- Weather conditions
- User demographics

## Aim

The primary goal of this analysis is to predict the number of bike rentals per hour and to understand the influences on rental behavior. The analysis will help in operational decisions, such as determining optimal bike distribution across stations.

## Dataset Characteristics

The dataset consists of 1500 hourly records and includes the following fields:

- `instant`: Record index
- `dteday`: Date
- `season`: Season (1: spring, 2: summer, 3: fall, 4: winter)
- `yr`: Year (0: 2011, 1: 2012)
- `mnth`: Month (1 to 12)
- `holiday`: Indicates if the day is a holiday
- `weekday`: Day of the week
- `workingday`: Indicates if the day is a working day
- `weathersit`: Weather conditions
- `temp`: Normalized temperature in Celsius
- `atemp`: Normalized feeling temperature in Celsius
- `hum`: Normalized humidity
- `windspeed`: Normalized wind speed
- `casual`: Count of casual users
- `registered`: Count of registered users
- `cnt`: Total count of rental bikes (response variable)

## Tasks

1. Perform descriptive data analysis and visualizations to gain insights into the dataset.
2. Implement predictive modeling:
   - a) Apply Lasso regression for covariate selection.
   - b) Use stepwise methods to finalize the model.
3. Check model assumptions and refine the approach.
4. Interpret parameters and evaluate the model's performance.
5. Assess out-of-sample predictive ability using the test dataset and compare models.
6. Describe the typical profile of bike rentals for each season.
7. Write a comprehensive report summarizing the results and findings.
