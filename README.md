# Predicting Titanic passenger survival
This is my submission to the "Titanic - Machine Learning from Disaster" challenge from Kaggle (https://www.kaggle.com/c/titanic/).
For this challenge, I built a logistic regression classifier to predict the survival of passengers aboard the Titanic.
I was given a dataset of passengers which include the following features: 
Passenger ID, ticket class, sex, age, number of siblings or spouse aboard the Titanic, number of children or parents abord the Titanic, ticket number,
passenger fare, cabin number, and port of embarkation. 

## Pre-processing: Dealing with missing values
The Age category had a lot of missing values, which I replaced with the mean of the feature.
The Embark category had 2 missing values. For this case, I removed the two rows with missing information.

## Data Analysis
I started with some density plots to get a sense of the data that I was dealing with.

Right off the bat, I notice that our training set is not balanced. There are a lot more cases of passengers not surviving than surviving. 
Perhaps this is meant to reflect the real-life situation.
<img width="300" alt="bar-survival" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/1a1b993c-52df-4cfc-9f3a-b6fa1faf329a">

Most passengers are between 20 and 40
<img width="300" alt="density-plot-age" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/bbfe16b8-bac3-4525-aead-9465f034fe9f">
