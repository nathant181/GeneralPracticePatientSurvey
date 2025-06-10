# Supervised learning analysis of General Practice Patient Survey

## Introduction


This code performs a supervised learning analysis of data from the General Practice Patient Survey. The survey participants were patients at general medical practices in England. The survey data, including details of cleansing methods and weightings applied, can be found at [https://gp-patient.co.uk/](https://gp-patient.co.uk/ 'GP Patient Survey website').

The analysis seeks to identify which of the questions asked in the survey have the strongest associations with overall satisfaction with the practice. Practices are classified into quartiles depending on the proportion of their respondents who agreed that their overall experience of the practice was good. Two different machine learning algorithms are then used to find the set of weights for the remaining questions that best predicts the quartile for each practice.

This code was written by Nathan Thomas at the Black Country Integrated Care Board.
Contact: nathan.thomas6@nhs.net

This code is licenced under an [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/ 'Open Government Licence v3.0').


## Summary


A supervised learning analysis of General Practice Survey results of 4,579 general practices in England found that questions related to how patients felt they were treated during their appointment and to the ease of contacting the practice and making an appointment had the strongest associations with overall patient satisfaction. Two different supervised learning algorithms were used and produced similar results, strengthening confidence in the findings.


## Method


GP Patient Survey results for all GP practices in England were obtained from the survey website. The full dataset included 6,307 GP practices (2024).


Questions in the survey that did not easily reduce to a single meaningful summary result were removed from the dataset used for analysis. Questions regarding NHS dentistry services were also removed. This left 29 questions, each expressed as a percentage of survey respondents for each practice answering in a certain way.


Practices that did not have a valid response for one or more of the selected questions were removed from the analysis, leaving 4,579 practices.


Practices were classified into quartiles depending on the proportion of their respondents who agreed that their overall experience of the practice was good. This is the predicted variable for the analysis; the remaining 28 questions were used as predictor variables or features.


A supervised learning analysis was undertaken on the dataset using R v4.4.1, in order to find the set of weights across all 28 features that was best at predicting the predictor variable (i.e. the overall satisfaction quartile to which each practice belongs). The dataset was split into training and test datasets on a 70/30 basis, and a model built using the training dataset. The model was then tested on the test dataset and model features analysed. Both linear discriminant analysis (LDA) and Gradient Boosted Machine (GBM) algorithms were used.


## Results


The optimum model identified by the linear discriminant analysis had three linear discriminants (three sets of weights that combine to give an overall prediction). These discriminants were themselves weighted, with the first discriminant accounting for 98% of the final prediction. As a result, only the first discriminant was considered when interpreting the results.


When tested on the test dataset, both the LDA and GBM models were about 70% accurate in predicting the overall satisfaction quartile of practices.


Strength of association with overall satisfaction was measured by the coefficients (weights) of the first discriminant in the LDA model and the mean dropout loss in the GBM model. Both models identified questions regarding the care and concern shown by health professionals, the helpfulness of reception staff, and the ease of getting through to the practice on the phone as having the strongest associations with overall satisfaction. The models showed less agreement about the questions that had the weakest associations with overall satisfaction, but being offered a choice of health professional, helpfulness of a plan to manage long-term conditions or illnesses, and condition or illness reducing ability to carry out day-to-day activities were all found to be weakly associated by both models.


## Discussion


Using two different supervised learning algorithms to analyse the data and observing similar results improves confidence in the robustness of the analysis. Futhermore, we can see from the tables of features ordered by strength of association with overall satisfaction that the results make intuitive sense. The high weighting given to questions related to access, such as ease of getting through on the phone and being satisfied with the appointment offered, chimes with concerns frequently raised in the media regarding perceptions of access to general practice services.


The models also suggest that the way in which patients are treated by both clinicians and non-clinicians during their appointment (for example, did they feel treated with care and concern, or were the reception staff helpful) has a greater bearing on their overall satisfaction than things like whether they saw a preferred GP or whether they had used the practice's online services. This suggests that practices can improve overall patient satisfaction by ensuring that all patients are treated respectfully and with care and dignity.


Analysis of the model suggests that the demographic characteristics of the patient (age, gender, sexuality, race, disability status, employment status, and parental status) had much less of a bearing on how satisfied patients were with their experience of their practice than other features such as how they felt treated by practice staff.


### Limitations

The analysis does not provide information on the extent to which features are correlated, which could affect the accuracy of the weight or importance assigned to each feature. A more thorough analysis would examine the correlations between features.


Additionally, the analysis does not control for demographic differences between patient populations. The survey scores were weighted to account for differences between those from each practice who responded to the survey and the total practice population, but not for differences between practice populations. It may be the case that practices with patient populations that differ demographically have different factors associated with a good overall patient experience.


This analysis, like the survey itself, focuses on patients’ judgements of their experience of their GP practice, which isn’t the only important measure of GP practice performance – things like quality of care, patient safety, and staff experience matter too.


It must be stressed that variables that don’t have a strong association with how a patient population in general experiences their practice can still be very important in determining the experience of individuals. For example, feeling that mental health needs are understood may not be that important for the majority who are in good mental health, but can be critical for those individuals whose mental health is poor. Following the implications of this analysis to strengthen workforce interpersonal skills should help practice staff better respond to individual care needs.


Finally, the analysis only provides evidence of association, not causation: a full causal inference analysis may provide more insight into factors that lead patients to rate their overall satisfaction with their general practice highly or poorly.


## Conclusion


Looking at the General Practice Staff Survey data through the lens of supervised learning provides useful information regarding which questions in the survey have the strongest association with overall patient satisfaction. This information can be used by general practices who wish to improve the satisfaction of their patients with their experience.


According to the models produced through this analysis, the questions with the strongest association with overall patient satisfaction relate to how the patient feels treated during their appointment, and also to the ease of contacting the practice and arranging an appointment.


The survey data that is publicly available does not allow for an analysis of whether the satisfaction of patients from different demographic groups is associated with different questions in the survey. For example, certain questions could have a larger bearing on the satisfaction of older patients than on that of younger patients, or a larger bearing on the satisfaction of patients with long-term health conditions than on that of those without such conditions. Should the survey data be made available in a form that allows for such relationships to be tested, this would be an interesting avenue for further analysis.
