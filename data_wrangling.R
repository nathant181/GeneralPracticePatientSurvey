# Supervised Learning analysis of General Practice Patient Survey 2024

## This code performs a supervised learning analysis of data from the 2024 General Practice Patient Survey using two different approaches.

## Author: Nathan Thomas
## Contact: nathan.thomas6@nhs.net
## Licence: Open Government Licence v3.0


# Step 1: Import necessary libraries ----
library(tidyverse)


# Step 2: Load the data ----
## Download data from https://gp-patient.co.uk/surveysandreports. Select the required year, then select 'Practice data (.csv)' from the GP Practice drop-down and press 'Go'. Save the downloaded file to the current working directory. The following code assumes that you are using the 2024 results.

## Import data
data <- read.csv("GPPS_2024_Practice_data_(weighted)_(csv)_PUBLIC.csv", header = TRUE)
data <- as_tibble(data)

summary(data)


# Step 3: Clean the data ----
## Select the "pcteval" columns that contain the results needed for the analysis
data <- data |> 
  dplyr::select(
    matches("*pcteval*")
  )

## Remove survey questions that don't reduce to a simple percentage result or relate to patient experience
data <- data |> dplyr::select(
  !contains("ethnicity") & !contains("religion") & !contains("agemerged") & -c(gpcontactwhen.pcteval, lastgpapptwhen.pcteval, localgpservicesprefhp.pcteval)
)

## Remove survey questions that don't relate to general practice
data <- data |> dplyr::select(
  !contains("gpclosed")
)

## Remove summary and duplicate measures
data <- data |> dplyr::select(
  -c(gpcontactoverall.pcteval, lastgpappttype.pctevalb)
)

## Drop rows with missing data
data <- data |> filter(if_all(matches("*pct*"), ~ . >= 0))


# Step 5: Create new column containing quartiles ----
data$QuartGoodOverallExp <- findInterval(data$overallexp.pcteval, quantile(data$overallexp.pcteval, c(0, .25, .5, .75)))
data <- data |>
  mutate(QuartGoodOverallExp = as.factor(QuartGoodOverallExp))