# Predicting Titanic passenger survival
This is my submission to the "Titanic - Machine Learning from Disaster" challenge from Kaggle (https://www.kaggle.com/c/titanic/).
For this challenge, I built a logistic regression classifier to predict the survival of passengers aboard the Titanic.
I was given a dataset of passengers which include the following features: 
Passenger ID, name, ticket class, sex, age, number of siblings or spouse aboard the Titanic, number of children or parents aboard the Titanic, ticket number,
passenger fare, cabin number, and port of embarkation. 

## Pre-processing: Dealing with missing values
The Age category had a lot of missing values, which I replaced with the mean of the feature.
The Embark category had 2 missing values. For this case, I removed the two rows with missing information.

## Data Analysis
I started with some density plots to get a sense of the data that I was dealing with.

Right off the bat, I notice that our training set is not balanced. There are a lot more cases of passengers not surviving than surviving. 
Perhaps this is meant to reflect the real-life situation.

<p align="center">
<img width="600" alt="bar-survival" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/1a1b993c-52df-4cfc-9f3a-b6fa1faf329a">
</p>

<p align="center">
<img width="600" alt="density-plot-age" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/bbfe16b8-bac3-4525-aead-9465f034fe9f">
</p>

<p align="center">
<img width="600" alt="density-ticket-fares" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/bccdafec-5241-493e-b0ba-565281220ce2">
</p>

There were a lot more men than women aboard the Titanic. 
<p align="center">
<img width="600" alt="Screenshot 2024-05-22 at 9 34 27 PM" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/339e957b-a02e-4fcc-bc1a-afb14676db69">
</p>

I watched the movie. I know that women and children were given preference when boarding lifeboats. I predict sex will play an important role in survival.

<p align="center">
<img width="600" alt="survival-sex" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/ee726d1e-a7a0-40a0-81be-2bfc33c00705">
</p>

Indeed, women were more likely to survive. 

I made a similar graph for passenger survival based on ticket class. From watching the movie, I (correctly) inferred that people in third class has the least chance of survival.

<p align="center">
<img width="600" alt="Screenshot 2024-05-22 at 9 45 24 PM" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/45a54cdf-6969-4432-bca7-6341d9980e97">
</p>

Here's another look:

<p align="center">
<img width="600" alt="survival-class" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/8a96a0aa-9292-4668-9f88-1995a5137490">
</p>

<p align="center">
<img width="450" alt="Screenshot 2024-05-22 at 9 53 38 PM" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/6ab5ccab-56cb-4f19-b4fb-55a1fc2bd8bf">

<img width="450" alt="SibSp" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/7bf91248-45b8-4e4b-97e7-0642c36d68ee">
</p>

At first I thought a lot of passengers were traveling alone. I combined the features for the number of siblings, spouse, children or parents aboard the Titanic and found that 
none of the passengers in the dataset were traveling alone.

<p align="center">
<img width="600" alt="withFam" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/4db15ecb-3650-4d45-a8d7-f2de6302bf15">
</p>

I created a correlation matrix to see if there were any features that were highly correlated.

<p align="center">
<img width="662" alt="Screenshot 2024-05-22 at 10 06 14 PM" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/7baf8f46-7665-4043-8208-388ec08c32ef">
</p>

## Logistic regression

I deleted features I knew would not be useful like passenger IDs, names, and cabin numbers. I also deleted the feature WithFam. This feature is the one where I assessed how many
family members a passenger was traveling with.

I trained a logistic regression model and tested it.
<p align="center">
<img width="450" alt="summary" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/834a86bb-1c1b-4b3e-bcc6-d2893048952b">
</p>
As we inferred during our data analysis, sex and ticket class are the most relevant features for the model. 

<p align="center">
<img width="450" alt="deviance table" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/62a757b2-74ee-447f-9882-755ac70aa9ac">
</p>

<p align="center">
<img width="450" alt="r2" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/5e140766-06ce-4b5e-9afc-41dc952ea6a3">
</p>
  
## Results
The accuracy of the model is 84%. 

The area under the curve is 86% which indicates the data is a good fit.

<p align="center">
<img width="680" alt="Screenshot 2024-05-22 at 10 02 51 PM" src="https://github.com/angelelliott/kaggle-titanic-survivor-predictive-analysis/assets/79605544/8bc1c494-9c07-4179-a2b8-ee6001748421">
</p>
