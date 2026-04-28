# Metadata

Project : Recurrence Decision System
Author  : Jing Liao
Last updated date  : 28-04-2026
Stakeholders       : die Menschen


## 1. Purpose

This project extends a simple recurrence pridction model (Project, recurrence_modelling) into a small decision-support pipeline.
It demonstrates how model outputs can be validated, interpreted, and translated into actionable risk tiers.


## 2. Dependencies

- R version 4.5.0
- Required R packages, details see R/


## 3. Project Overview

This decision supporting project is an extension of the Recurrence Modelling Project. 
It additionally includes validation checks on prediction outputs and convert predictions into risk tiers and suggested actions.
The workflow is as below:

simulate_data -> features -> model -> prediction -> validation -> decision -> report

## 4. Architecture/Structure

```text

my_ds_portfolio/portfolio_projects/recurrence_decision_system/
|----- recurrence_decision_system.Rproj
|----- README.md
|----- _targets.R
|----- _targets/ (do not commit this file)
|----- R/
       |----- load_packages.R
       |----- simulate_data.R
       |----- feature_engineering.R
       |----- model.R
       |----- validation.R
       |----- decision.R
|----- report/
       |----- decision_report_files/ 
       |----- decision_report.qmd
       |----- decision_report.html

```


## 5. Criteria/Business Rules

### Simulated Data

1. The data includes the following variables:
   - personal identification
   - risk level of having episode recurrence
   - recurrence probability
   - first episode start and end date
   - second episode start date
   - a binary recurrence flag (whether the second episode happens within 180 days)
   
2. The binary recurrence outcome (Y as whether an event will recur within 180 days) is generated based on **risk level**:
  - Risk levels (low, medium, high) are independently sampled with probabilities: 0.5, 0.3, and 0.2
  - Recurrence probability is predefined to connect the risk levels:
    - low risk level with 0.2 recurrence probability
    - medium risk with 0.4 recurrence probability
    - high risk with 0.7 recurrence probability
  - The binary outcome is generated using a binomial sampling process with the predefined recurrence probability

3. Episode duration is generated **randomly and independently**:
  - First episode start dates are sampled between 01/01/2022 and 31/12/2022
  - Episode duration (the difference between first episode start and end date) ranges from 1 to 10 days
  - Second episode start dates are defined as:
    - first episode end date + gap days (if recurrence occurs, i.e. Y = 1)
    - gap days are randomly sampled between 10 and 180 days

### Feature Engineering

1. Risk number (1,2,3) is encoded by risk level from low, medium to high level
2. Episode type (short, medium, long) is defined based on the first episode duration: within 3 days, between 3 and 6 days, and exceeding 6 days
3. Risk duration interaction is the product of numeric encoded risk level and first episode duration, e.g. high risk and prolonged event may be more likely to event recurrence

### Modelling

To estimate probability of event recurrence, a logistic regression model is used with the glm family binomial distribution.
The features considered in the model are risk level and either first episode duration (continuous) or episode type (categorical).

### Prediction

1. According to the model fitting from the modelling process, input the simulated data as new data set to do prediction.
2. Set a prediction class and relate it to the response variable Y. If the predicted probability is 0.5+, then the recurrence outcome is Yes, otherwise, No

### Model evaluation

Evaluation is to compare what has been observed with what is predicted in the following two aspects:

- Confusion: a table to compare the binary recurrence outcome Y between observations and predictions
- Accuracy: a proportion of observed Y matched the predicted Y
- Baseline: a baseline representing the accuracy achieved by a naive model that always predicts the majority class

### Prediction validation

The purpose of validation on prediction outputs is to ensure data quality and logical reliability.

1. Prediction outputs should include the following columns: 
   - risk level
   - predicted recurrence outcome within 180 (y)
   - predicted probability 
   - prediction class
   
2. Missing values should be identified in the above required columns
3. The predicted probability must range between 0 and 1 (i.e. not NA or out of the range)
4. The prediction class outcome should be either 0 or 1
5. The outcome of the risk level should only consist of low, medium and high

### Supporting decisions  

1. Risk tier is associated with the predicted probability and is defined when
   - High risk tier     : predicted probability >= 0.7
   - Medium risk tier   : predicted probability is [0.4, 0.7)
   - Low risk tier      : predicted probability is <0.4
   
2. Suggested action associated with the Risk tier is defined when
   - High risk tier     : prioritise follow-up
   - Medium risk tier   : monitor
   - Low risk tier      : routine review
   - Others unspecified : check


## 6. Deployment

To reproduce the report locally, simply navigate to report/model_report.qmd and render the file, 
or execute `quarto::quarto_render("report/model_report.qmd")` in the Console in this project directory.

## 7. Outputs
Currently only an HTML report is available through quarto.

## 8. Known Issues/To Do
This is an in-sample prediction, as predictions are generated on the same simulated data used for training. 
In a production setting, a train-test split (out-of-sample evaluation) would be used to obtain unbiased performance estimates. 
E.g. use 70% of simulated data for model training and 30% for evaluation.

## 9. Useful Commands
The design/ folder is used for demonstration purposes only. It is not part of the project pipeline or workflow.



## Deployment

run the pipeline via code below in console:

```{r}
library(targets)
tar_make()
```
## Key idea

This project is not about building a more complex model. It focuses on:

turning model outputs into something that can actually be used

## Structure

- R/
  |----- simulate_data.R
  |----- feature_engineering.R
  |----- model.R
  |----- validation.R
  |----- decision.R
- report/
  |----- decision_report.qmd
- _targets.R

## Notes

- Data is simulated for demonstration purposes
- Risk tiers are based on simple thresholds
- The emphasis is on workflow design reather than model performance

-----------------------------------------

Operationalising recurrence prediction into a reproducible decision-support workflow for cross-functional use.
The goal of this project is to demonstrate my competency, not only building models but also:
- how to design models into procedures
- how to deal with mistaken data
- how to turn outputs to actions
- how to let cross-functional team use this system

This project answers the question, 'What should we do next' after project 2 and pinpoints these items:
- turn model score to decision tier
- validation and trust layer
- pipeline orchestration
- operational reporting
- ownership and workflow thinking

The core of this project includes:
1. to determine risk tier and suggested actions for each individual with validation to enable architect/governance thinking:
- required columns check
- duplicate key check
- impossible sequence check
- missingness summary
- risk score range check
- data drift / unexpected distribution shift
- output row count check

e.g. second episode date is earlier than first episode date, 
     negative duration
     duplicated person_id + index_date
     risk score is out of the range of (0,1)
     risk tier has missing value
     the ratio of high risk cases is plumeted 

2. operational layer to clarify:

- pipeline runs weekly/monthly
- who reads the report
- what decisions the output informs
- what to do when validation fails
- what to do when model confidence drops

# placeholder, complete this readme file

Purpose for each R script:
1. ingestion.R
   read data and standardise columns
2. episode.R
   episode
3. features.R
   only use index episode
4. model.R
   model
5. scoring.R
6. decision.R
7. validation.R


