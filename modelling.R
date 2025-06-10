# Supervised Learning analysis of General Practice Patient Survey 2024

## This code performs a supervised learning analysis of data from the 2024 General Practice Patient Survey using two different approaches.

## Author: Nathan Thomas
## Contact: nathan.thomas6@nhs.net
## Licence: Open Government Licence v3.0


#! run data_wrangling.R first !#


# Step 6: Import necessary libraries ----
library(tidymodels)
library(MASS)
library(discrim)
library(lightgbm)
library(DALEX)
library(DALEXtra)
library(bonsai)


# Step 7: Create Training and Test samples ----

## make this example reproducible
set.seed(1)

## Use 70% of dataset as training set and remaining 30% as test set
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob = c(0.7,0.3))
train <- data[sample, ]
test <- data[!sample, ]


# Step 8: Define LDA model ----
lda_model <- discrim_linear() |>
  set_engine("MASS") |>
  translate()

lda_model


# Step 9: select predictor variables and create model formula ----
predictors <- data |>
  dplyr::select(-c(overallexp.pcteval, QuartGoodOverallExp)) |>
  colnames()

formula <- as.formula(paste("QuartGoodOverallExp ~ ", paste(predictors, collapse = "+")))
print(formula)


# Step 10: Fit the LDA model to the training data ----
lda_model_fit <- lda_model |>
  fit(formula, data = train)


# Step 11: Predict the test data ----
predicted <- predict(lda_model_fit, test)

## find accuracy of model
mean(predicted$.pred_class == test$QuartGoodOverallExp)


# Step 12: Interpret LDA model ----
## Check how much each linear discriminant contributes to the overall result - can we ignore all but the first discriminant?
lda_model_fit$fit$svd^2 / sum(lda_model_fit$fit$svd^2)

## create table
table <- as.data.frame(lda_model_fit$fit$scaling)

## order by variables that have the strongest association with the predicted variable in the first discriminant
table <- table[order(-abs(table$LD1)), ]

table


# Step 13: Format for sharing -----
## Convert row names to column
table$Measure <- row.names(table)
rownames(table) <- NULL

## Give variables intelligible names
rename_measures <- function(table) {
  table |>
    mutate(
      Measure = case_when(
        Measure == "lastgpapptneeds.pcteval" ~ "Were needs met at last appointment",
        Measure == "lastgpapptcare.pcteval" ~ "Treated with care at last appointment",
        Measure == "lastgpapptmental.pcteval" ~ "Consideration of mental wellbeing",
        Measure == "localgpservicesreception.pcteval" ~ "Helpfulness of reception staff",
        Measure == "gpcontactnextsteptiming.pcteval" ~ "Next step known within two days of contacting",
        Measure == "localgpservicesphone.pcteval" ~ "Easy to contact practice on the phone",
        Measure == "lastgpapptconf.pcteval" ~ "Confidence and trust in healthcare professional",
        Measure == "lastgpapptlisten.pcteval" ~ "Good at listening",
        Measure == "healthsupport.pcteval" ~ "Enough support to manage conditions or illnesses",
        Measure == "lastgpapptinfo.pcteval" ~ "Healthcare professional had all information needed",
        Measure == "healthconversation.pcteval" ~ "Conversation to discuss what is important",
        Measure == "lastgpapptdecision.pcteval" ~ "Involved in decisions about care and treatment",
        Measure == "healthconfidence.pcteval" ~ "Confident in managing health issues",
        Measure == "healthconditionre.pcteval" ~ "Health condition lasting 12 months or more",
        Measure == "gpcontactnextstep.pcteval" ~ "Next step following contact known",
        Measure == "lastgpapptwait.pcteval" ~ "Wait for appointment about right",
        Measure == "lastgpappttype.pcteval" ~ "Appointment was remote",
        Measure == "pharmacyoverall.pcteval" ~ "Good experience of pharmacy services",
        Measure == "localgpservicesapp.pcteval" ~ "Easy to contact practice through NHS app",
        Measure == "lastgpapptchoice.pcteval" ~ "Offered choice of appt time of day",
        Measure == "aboutyoucarer.pcteval" ~ "Carer for someone because of health or age",
        Measure == "healthcareplan.pcteval" ~ "Agreed a plan to manage conditions or illnesses",
        Measure == "healthimpact.pcteval" ~ "Condition or illness reduces ability to carry out day-to-day activities",
        Measure == "localgpserviceswebsite.pcteval" ~ "Easy to contact practice through website",
        Measure == "healthcareplanhelpful.pcteval" ~ "Plan for managing conditions or illnesses is helpful",
        Measure == "lastgpapptchoice.pctevalb" ~ "Offered choice of healthcare professional",
        Measure == "localgpservicesprefhpsee.pcteval" ~ "See preferred healthcare professional all or most of the time",
        .default = Measure
      )
    )
}

table <- rename_measures(table)

## format table
library(gt)
table_lda <- table |>
  dplyr::select(Measure, LD1) |>
  rename(Weight = LD1) |>
  #relocate(Measure, .before = Weight)
  gt() |>
  fmt_number(decimals = 2) |>
  tab_header(
    title = "Linear Discriminant Analysis",
    subtitle = "Measures ordered by first discriminant"
  )


# Step 14: Create the Gradient Boosted Machine model ----
gbm_model <-
  boost_tree(trees = 15) |>
  set_mode("classification") |>
  set_engine("lightgbm")

gbm_model

# Step 15: Fit the GBM model to the training data ----
gbm_model_fit <- gbm_model |>
  fit(formula, data = train)


# Step 16: Predict the test data ----
predicted <- predict(gbm_model_fit, test)

## find accuracy of model
mean(predicted$.pred_class == test$QuartGoodOverallExp)


# Step 17: Interpret GBM model ----
explainer <- explain_tidymodels(
  gbm_model_fit,
  data = train,
  y = train$QuartGoodOverallExp,
  label = "DALEXtra"
)

## Extract mean dropout loss for each feature using cross entropy - the larger the mean dropout loss, the bigger the reduction in cross entropy and the bigger the improvement in prediction
var_imp <- model_parts(explainer, loss_function = loss_cross_entropy, type = "raw")


# Step 15: Create table of mean dropout losses -----

## create table
table <- as.data.frame(var_imp)

## order by variables that have the strongest association with the predicted variable
table <- table |> 
  filter(!variable %in% c("overallexp.pcteval", "QuartGoodOverallExp")) |>
  group_by(variable) |>
  summarise(mean_dropout_loss = mean(dropout_loss)) |>
  arrange(desc(mean_dropout_loss)) |>
  rename(Measure = variable)

## print table
table

# Step 16: Format for sharing ----
table <- rename_measures(table)

## format table
library(gt)
table_gbm <- table |> 
  gt() |>
  tab_header(
    title = "Gradient Boosted Machine",
    subtitle = "Measures ordered by mean dropout loss"
  )

# Save tables to Rdata for incorporating into Quarto files
save(list = c("table_lda", "table_gbm"), file = "tables.Rdata")