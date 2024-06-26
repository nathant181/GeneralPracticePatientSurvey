# Canonical discrimination analysis of General Practice Patient Survey 2023

## This code performs a canonical discrimination analysis of data from the 2023 General Practice Patient Survey.

## Author: Nathan Thomas
## Contact: nathan.thomas6@nhs.net
## Licence: Open Government Licence v3.0



# Step 1: Load necessary libraries ----

library(MASS)
library(ggplot2)
library(stringr)
library(formattable)


# Step 2: Load the data ----

data <- read.csv('LDA_General_Practice_Staff_Survey_2023.csv',
                 header = TRUE)

attach(data)
str(data)


# Step 3: Identify quartiles ----

## create new column containing quartiles
data$QuartGoodOverallExp <- findInterval(data$GoodOverallExperience, quantile(data$GoodOverallExperience, c(0, .25, .5, .75)))


# Step 4: Create Training and Test samples ----

## make this example reproducible
set.seed(1)

## Use 70% of dataset as training set and remaining 30% as test set
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob = c(0.7,0.3))
train <- data[sample, ]
test <- data[!sample, ]


# Step 5: Fit the linear (canonical) discrimination model ----

## select predictor variables
cols <- c("LongTermCondition", "InPerson", "WithGP", "SatisfiedOffer", "EasyToGetThrough", "HelpfulReception", "NotUsedOnlineServices", "WebsiteEasyToUse", "HavePreferredGP", "OftenSeePreferredGP", "DidNotTryToGetInfo", "OfferedChoice", "SameDay", "GivingYouEnoughTime", "ListeningToYou", "CareAndConcern", "UnderstoodMentalHealthNeeds",    "Involved", "ConfidenceAndTrust", "NeedsMet", "Avoided", "LongCovid", "GoodExperienceWhenClosed", "White", "Aged65OrOver", "Aged85OrOver", "PermanentlySickOrDisabled", "Unemployed", "Carer", "ParentOrGuardian", "NeverSmoked", "Heterosexual")

predictors <- paste(cols, sep = "")
formula <- as.formula(paste("QuartGoodOverallExp ~ ", paste(predictors, collapse = "+")))
print(formula)

## fit model
model <- lda(formula, data = train)

## view model output
model


# Step 6: Use the model to make predictions ----

## use model to make predictions on test data
predicted <- predict(model, test)

names(predicted)

## view predicted class for first six observations in test set
head(predicted$class)

## view posterior probabilities for first six observations in test set
head(predicted$posterior)

## view linear discriminants for first six observations in test set
head(predicted$x)

## find accuracy of model
mean(predicted$class == test$QuartGoodOverallExp)


# Step 7: Visualise the results ----

## define data to plot
lda_plot <- cbind(train, predict(model)$x)

## create plot
ggplot(lda_plot, aes(LD1, LD2)) +
  geom_point(aes(colour = factor(QuartGoodOverallExp))) +
  scale_colour_manual(values = c("#0269f9", "#C64189", "#F39200", "#65B330"))

ldahist(data = predict(model)$x[,1], g = train$QuartGoodOverallExp)


# Step 8: Create table of linear discriminants

## create table
table <- as.data.frame(model$scaling)

## order by variables that have the strongest association with the predicted variable in the first discriminant
table <- table[order(-abs(table$LD1)), ]

## print table
table