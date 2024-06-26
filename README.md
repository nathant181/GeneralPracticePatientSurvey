# Linear discriminant analysis of General Practice Patient Survey 2023

## Introduction


This code performs a canonical discrimination analysis of data from the 2023 General Practice Patient Survey. The survey participants were patients at general medical practices in England. The survey data, including details of cleansing methods and weightings applied, can be found at [https://gp-patient.co.uk/](https://gp-patient.co.uk/ 'GP Patient Survey website').

The analysis seeks to identify which of the questions asked in the survey have the strongest associations with overall satisfaction with the practice. Practices are classified into quartiles depending on the proportion of their respondents who agreed that their overall experience of the practice was good. A machine learning algorithm is then used to find the set of weights for the remaining questions that best predicts the quartile for each practice.

This code was written by Nathan Thomas at the Black Country Integrated Care Board.
Contact: nathan.thomas6@nhs.net

This code is licenced under an [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/ 'Open Government Licence v3.0').


## Summary


A linear discriminant analysis of 2023 General Practice Survey results of 5,810 general practices in England found that questions related to how patients felt they were treated during their appointment and to the ease of contacting the practice and making an appointment had the strongest associations with overall patient satisfaction.


## Method


2023 GP Patient Survey results for all GP practices in England were obtained from the survey website. The full dataset included 6,419 GP practices.


Questions in the survey that did not easily reduce to a single meaningful summary result were removed from the dataset used for analysis. Questions regarding NHS dentistry services were also removed. This left 36 questions, each expressed as a percentage of survey respondents for each practice answering in a certain way.


Practices that did not have a valid response for one or more of the selected questions were removed from the analysis, leaving 5,810 practices.


Practices were classified into quartiles depending on the proportion of their respondents who agreed that their overall experience of the practice was good. This is the predicted variable for the analysis; the remaining 35 questions were used as predictor variables.


A linear discriminant analysis was undertaken on the dataset using R v4.4.0, in order to find the set of weights across all 35 predictor variables that was best at predicting the predictor variable (i.e. the quartile to which each practice belongs). The dataset was split into training and test datasets on a 70/30 basis, and a model built using the training dataset. The model was then tested on the test dataset and model features analysed.


## Results


The optimum model identified by the analysis has three linear discriminants (three sets of weights that combine to give an overall prediction). These discriminants were themselves weighted, with the first discriminant accounting for 97% of the final prediction.


When tested on the test dataset, the model was about 70% accurate in predicting the overall satisfaction quartile of practices.


Questions regarding the care and concern shown by health professionals, the helpfulness of reception staff, and the ease of getting through to the practice on the phone had the highest weights in the first discriminant, and questions regarding disability status, ethnicity, and mental health needs had the lowest weights.


## Discussion


As model predictions were based almost entirely on the first discriminant, we ignored the second and third discriminants and focused on the interpretation of the first discriminant. The higher the weight given to each of the predictor variables in the first discriminant, the stronger its association with the predicted variable. For weights that were positive, a higher score on this survey question is associated with a higher score on the overall satisfaction question; for weights that were negative, a higher score on this survey question is associated with a lower score on the overall satisfaction question.


We can see from the table of predictor variables ordered by their first discriminant weighting that the weights applied make intuitive sense. The high weighting given to questions related to access, such as ease of getting through on the phone and being satisfied with the appointment offered, chimes with concerns frequently raised in the media regarding perceptions of access to general practice services.


The model also suggests that the way in which patients are treated by both clinicians and non-clinicians during their appointment (for example, did they feel treated with care and concern, or were the reception staff helpful) has a greater bearing on their overall satisfaction than things like whether they saw a preferred GP or whether they had used the practice's online services. This suggests that practices can improve overall patient satisfaction by ensuring that all patients are treated respectfully and with care and dignity.


Analysis of the model suggests that the demographic characteristics of the patient (age, gender, sexuality, race, disability status, employment status, and parental status) had much less of a bearing on how satisfied patients were with their experience of their practice than other variables such as how they felt treated by practice staff. However, the model does not provide information on the extent to which predictor variables are correlated; for example, if patients with certain demographic characteristics were less likely to agree that they had been treated with care and concern, this would not be picked up by the model. A different approach would be required in order to assess the extent of correlations between variables, which may not be feasible with the limitations of the publicly available aggregated data.


Additionally, the analysis does not control for demographic differences between patient populations. The survey scores were weighted to account for differences between those from each practice who responded to the survey and the total practice population, but not for differences between practice populations. It may be the case that practices with patient populations that differ demographically have different factors associated with a good overall patient experience.


This analysis, like the survey itself, focuses on patients’ judgements of their experience of their GP practice, which isn’t the only important measure of GP practice performance – things like quality of care, patient safety, and staff experience matter too.


It must be stressed that variables that don’t have a strong association with how a patient population in general experiences their practice can still be very important in determining the experience of individuals. For example, feeling that mental health needs are understood may not be that important for the majority who are in good mental health, but can be critical for those individuals whose mental health is poor. Following the implications of this analysis to strengthen workforce interpersonal skills should help practice staff better respond to individual care needs.


# Conclusion


Looking at the General Practice Staff Survey data through the lens of a linear discriminant analysis provides useful information regarding which questions in the survey have the strongest association with overall patient satisfaction. This information can be used by general practices who wish to improve the satisfaction of their patients with their experience.


According to the model produced through this analysis, the questions with the strongest association with overall patient satisfaction relate to how the patient feels treated during their appointment, and also to the ease of contacting the practice and arranging an appointment.


The survey data that is publicly available does not allow for an analysis of whether the satisfaction of patients from different demographic groups is associated with different questions in the survey. For example, certain questions could have a larger bearing on the satisfaction of older patients than on that of younger patients, or a larger bearing on the satisfaction of patients with long-term health conditions than on that of those without such conditions. Should the survey data be made available in a form that allows for such relationships to be tested, this would be an interesting avenue for further analysis.