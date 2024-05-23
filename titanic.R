library(tidyverse)
library(tigris)
library(ggrepel)
library(RColorBrewer)
library(DBI)
library(RMySQL)
library(dplyr)
library(ggcorrplot)
library(pscl)
library(ROCR)


# Load training dataset
titanic_df <- read.csv("/Users/andrea/Documents/titanic/train.csv")
nrow(titanic_df)
# [1] 891

# Pre-processing: Dealing with missing values
sum(is.na(titanic_df))
# [1] 177
# There are a lot of missing values in the Age category 
# I'm just going to re-code them as the mean passenger age
titanic_df$Age[is.na(titanic_df$Age)] <- mean(titanic_df$Age, na.rm = TRUE)
sum(is.na(titanic_df))

#view(titanic_df)

# Let's start off with some density plots to get an idea of 
# the data we are dealing with 

# Age 
g <- ggplot(titanic_df, aes(Age))
g + geom_density(fill="#1B9E77" ) + 
  labs(title="Density plot", 
       subtitle="Age of Titanic passengers",
       x="Age",
       y="Density") +
  scale_fill_brewer(palette="Dark2")

# Survival
g <- ggplot(titanic_df, aes(factor(Survived)))
g + geom_bar(fill="#1B9E77", width=0.3) + 
  labs(title="Bar plot", 
       subtitle="Passengers that survived the sinking of the Titanic",
       x="Passenger did not survive (0) or survived (1)",
       y="Count") +
  scale_fill_brewer(palette="Dark2")

# Our training classes are not balanced. There are over a 100 more
# instances of passengers that did not survive
# This could be to reflect the reality of the situation 

# Fare
g <- ggplot(titanic_df, aes(Fare))
g + geom_density(fill="#1B9E77") + 
  labs(title="Density plot", 
       subtitle="Titanic ticket fares",
       x="Fare",
       y="Density") +
  scale_fill_brewer(palette="Dark2")

# Sex
g <- ggplot(titanic_df, aes(Sex))
g + geom_bar(fill="#1B9E77", width=0.3) + 
  labs(title="Bar plot", 
       subtitle="Passengers of the Titanic by sex",
       x="Sex",
       y="Count") +
  scale_fill_brewer(palette="Dark2")

# Number of siblings / spouses above the Titanic
g <- ggplot(titanic_df, aes(factor(SibSp)))
g + geom_bar(fill="#1B9E77", width=0.3) + 
  labs(title="Bar plot", 
       subtitle="Number of siblings or spouse aboard the Titanic for a single passenger",
       x="Number of siblings or spouse",
       y="Count")

# Most people in the dataset are traveling without a spouse or a sibling
# I'm interested in learning the gender distribution of passengers 
# especially those traveling alone

p <- ggplot(titanic_df, aes(as.factor(SibSp))) + 
  geom_bar(aes(fill=factor(Sex)), width=0.5) +
  ggtitle("Number of siblings or spouses aboard the Titanic given a single passenger grouped by Sex") +
  xlab("Number of siblings or spouse") + ylab("Count") + 
  labs(fill="Sex")+
  scale_fill_brewer(palette="Dark2")
p

# Indeed, a large portion of passengers are men traveling without
# a spouse or siblings
# This does not mean they're traveling alone, however
# I wonder if this dataset contains passengers who are each other's 
# spouse or sibling

# Number of parents / children aboard the Titanic
g <- ggplot(titanic_df, aes(factor(Parch)))
g + geom_bar(fill="#1B9E77", width=0.5) + 
  labs(title="Bar plot", 
       subtitle="Number of parents or children aboard the Titanic given a single passenger",
       x="Number of parents or children",
       y="Count") +
  scale_fill_brewer(palette="Dark2")

# Number of parents / children aboard the Titanic grouped by sex
p <- ggplot(titanic_df, aes(as.factor(Parch))) + 
  geom_bar(aes(fill=factor(Sex)), width=0.5) +
  ggtitle("Number of parents or children aboard the Titanic given a single passenger grouped by Sex") +
  xlab("Number of parents or children") + ylab("Count") + 
  labs(fill="Sex")+
  scale_fill_brewer(palette="Dark2")
p


p <- ggplot(titanic_df, aes(as.factor(Parch))) + 
  geom_bar(aes(fill=factor(Sex)), width=0.5) +
  ggtitle("Number of parents or children aboard the Titanic given a single passenger grouped by Sex") +
  xlab("Number of parents or children") + ylab("Count") + 
  labs(fill="Sex")+
  scale_fill_brewer(palette="Dark2")
p

# could do it by combining the features

# This distribution is very similar to the one about the siblings or 
# spouse. Also these categories do not make sense. It would be more 
# natural to pair the (children and spouse) and (parents and siblings)

# combining them, I'm curious to see how many people are traveling 
# without any family members

class(titanic_df$SibSp)
sum(is.na(titanic_df$SibSp))
titanic_df$SibSp <- as.integer(as.factor(titanic_df$SibSp))
titanic_df$WithFam <-titanic_df$SibSp + titanic_df$Parch
#view(titanic_df)

g <- ggplot(titanic_df, aes(factor(WithFam)))
g + geom_bar(fill="#1B9E77", width=0.5) + 
  labs(title="Bar plot", 
       subtitle="Number of family members aboard the Titanic given a single passenger",
       x="Number family members",
       y="Count") +
  scale_fill_brewer(palette="Dark2")
# No one in this dataset is traveling alone

# Bar plot of family member counts grouped by survival status
p <- ggplot(titanic_df, aes(as.factor(WithFam))) + 
  geom_bar(aes(fill=factor(Survived)), width=0.5) +
  ggtitle("Number of family members aboard the Titanic given a single passenger grouped by Survival") +
  xlab("Number of family members") + ylab("Count") + 
  labs(fill="Survived")+
  scale_fill_brewer(palette="Dark2")
p

# Bar plot of family member counts grouped by sex
p <- ggplot(titanic_df, aes(as.factor(WithFam))) + 
  geom_bar(aes(fill=factor(Sex)), width=0.5) +
  ggtitle("Number of family members aboard the Titanic given a single passenger grouped by Sex") +
  xlab("Number of family members") + ylab("Count") + 
  labs(fill="Sex")+
  scale_fill_brewer(palette="Dark2")
p
# No one in this dataset is traveling alone


# Bar plot of port of embarkment
g <- ggplot(titanic_df, aes(factor(Embarked)))
g + geom_bar(fill="#1B9E77", width=0.5) + 
  labs(title="Bar plot", 
       subtitle="Passengers by port of embarkment",
       x="Port of embarkment",
       y="Count") +
  scale_fill_brewer(palette="Dark2")

# I notice that there are passengers with an empty port of embarkment
# I'm just going to remove these rows from the dataset
titanic_df[which(titanic_df$Embarked == ""),]
titanic_df <- titanic_df[-c(62,830), ]
view(titanic_df)

#Bar plot of passenger survival by ticket class
p<- ggplot(titanic_df %>% count(Pclass, Survived),aes(x=as.factor(Survived), y=n, fill=as.factor(Pclass))) +
  geom_bar(stat="identity") +
  ggtitle("Survival of Titanic passengers by ticket class")+
  xlab("Passenger did not survived (0) or survived (1)")+
  ylab("Count")+
  labs(fill = "Passenger class") +
  scale_fill_brewer(palette="Dark2") 
p
# Most of the people that died were in third class, 
# but also most of the passengers in the Titanic were in third class 

# Histogram of passengers of the Titanic by ticket class (1,2,3rd class)
p <- ggplot(titanic_df, aes(as.factor(Pclass))) + 
  geom_bar(aes(fill=as.factor(Survived)), width=0.5) +
  ggtitle("Passengers of the Titanic by ticket class") +
  xlab("Passenger class") + ylab("Count") + 
  labs(fill="Survived (1)")+
  scale_fill_brewer(palette="Dark2")
p

# Somewhat similar numbers from first and second class died
# but the majority of people in third class died
# points towards disproportions between ticket classes

# Let's look at ticket prices 
g <- ggplot(titanic_df, aes(Fare))
g + geom_density(aes(fill=factor(Survived)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="Ticket fare grouped by passenger survival",
       x="Fare",
       y="Density",
       fill="Survived (0)") +
  scale_fill_brewer(palette="Dark2")
  

# Based on the movie Titanic, 
# I can infer that gender will play a role in survival
# Histogram of passengers of the Titanic by gender
p <- ggplot(titanic_df, aes(Sex)) + 
  geom_bar(aes(fill=as.factor(Survived)), width=0.5) +
  ggtitle("Passengers of the Titanic by gender") +
  xlab("Passenger gender") + ylab("Count") + 
  labs(fill="Survived (1)")+
  scale_fill_brewer(palette="Dark2")
p
# Even though there were more male passengers in this dataset, 
# female passenger survivors greatly outnumbered male passenger survivors 

brewer.pal(n = 8, name = "Dark2")


# Pre-processing: prepare data for logistic regression

# Remove columns that I know will not be useful
titanic_df <- subset(titanic_df, select=-c(PassengerId, Name, Ticket, Cabin))
view(titanic_df)

# Categorical columns
#titanic_df$Sex<-c(female=0,male=1)[titanic_df$Sex]
#titanic_df$Embarked<-c(S=0,Q=1,C=2)[titanic_df$Embarked]
view(titanic_df)
is.factor(titanic_df$Sex)
titanic_df$Sex <- as.factor(titanic_df$Sex)
is.factor(titanic_df$Embarked)
titanic_df$Embarked <- as.factor(titanic_df$Embarked)

# Correlation matrix
model.matrix(~0+., data=titanic_df) %>% 
  cor(use="pairwise.complete.obs") %>% 
  ggcorrplot(show.diag=FALSE, type="lower", lab=TRUE, lab_size=2,
             colors = brewer.pal(n = 8, name = "Dark2"))
# I will delete the variable WithFam since it is redundant and highly correlated to SibSp and Parch
titanic_df <- subset(titanic_df, select=-c(WithFam))

train<-titanic_df[1:800,]
test<-titanic_df[801:889,]

# Train model 
model <- glm(Survived ~.,family=binomial(link='logit'),data=train)

# p-value
summary(model)
# Parch, Fare, and Embarked variables are not statistically significant
# p-value is > 0.05
# sex and passenger class are the most statistically relevant variables, 
# as we predicted during our data analysis

anova(model, test="Chisq")
# Oarch, SibSp, Fare, and Embarked have low deviance

pR2(model)

# Let us test the model

# the test set has some null values which I will just remove

fitted_results <- predict(model,newdata=test,type='response')
fitted_results <- ifelse(fitted_results > 0.5,1,0)
misClasificError <- mean(fitted_results != test$Survived)
print(paste('Accuracy',1-misClasificError))
# For the first time running this model with no hyperparameter tuning, 
# 84% accuracy is pretty good

p <- predict(model, newdata=test, type="response")
pr <- prediction(p, test$Survived)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc
# AUC is 0.86 which indicates that our model is a pretty decent fit
