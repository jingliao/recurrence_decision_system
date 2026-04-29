# Metadata

```text

Project             : Recurrence Decision System (Proof of Concept)
Author              : Jing Liao
Last updated date   : 28-04-2026
Stakeholders        : die Menschen

```

# Quick Entry View

- project summary, see this README
- pipeline design, see `design/DAG.html`
- example output, see `reports/decision_report.html`

## 1. Purpose

This project is a proof-of-concept designed to illustrate how decision-support workflows can be structured. 
It extends a simple recurrence prediction model (Recurrence Modelling Project) into a small decision-support pipeline.
It demonstrates how model outputs can be validated, interpreted, and translated into actionable risk tiers.

## 2. Dependencies

- R version 4.5.0
- Required R packages, details see R/


## 3. Project Overview

This decision supporting project is an extension of the Recurrence Modelling Project. 
It additionally includes validation checks on prediction outputs and convert predictions into risk tiers and suggested actions.

The complete workflow is: simulate_data -> features -> model -> prediction -> validation -> decision -> report

The goal is to operationalise recurrence prediction into a reproducible decision-support workflow for cross-functional use.

It aims to achieve the following:

- how to design models into procedures
- how to handle data quality issues
- how to turn outputs to actions
- how to let cross-functional team use this system

This project answers the question: What should we do next after Recurrence Modelling Project and pinpoints on:

- turn model score to decision tier
- validation and trust layer
- pipeline orchestration
- operational reporting
- ownership and workflow thinking

## 4. Architecture/Structure

```text

my_ds_portfolio/portfolio_projects/recurrence_decision_system/
|----- recurrence_decision_system.Rproj
|----- run_pipeline.R
|----- README.md
|----- _targets.R
|----- _targets/ (pipeline cache, excluded from version control)
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
|----- design/
       |----- pipeline_visualisation.R
       |----- DAG.html
       |----- DAG_files

```


## 5. Criteria/Business Rules

### Simulated Data

1. The data includes the following variables:
   - synthetic person_id
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
e.g. second episode date is earlier than first episode date, negative duration, risk tier has missing values, ... etc.

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
   
2. Example "suggested action" associated with each rsk tier is defined when
   - High risk tier     : prioritise follow-up
   - Medium risk tier   : monitor
   - Low risk tier      : routine review
   - Others unspecified : check

## 6. Deployment

To reproduce the report locally, simply run the following code in the console in this project directory.
`source("run_pipeline.R")`

`run_all(openReport = TRUE)` 

The `run_all()` function is the entry point to execute the entire project. 
The argument `openReport = TRUE` indicates a report will be displayed through an HTML page. 
If `openReport = FALSE`, all the code will be executed without showing the report page. 
This is for non-reporting purpose such as data updates and debugging.

## 7. Outputs
Currently only an HTML report is available through quarto.

## 8. Known Issues/To Do
As it is an extension of Recurrence Modelling Project, in-sample prediction is used. Details, see recurrence_modelling/README.md. 

## 9. Useful Commands
The design/ folder is used for demonstration purposes only. It is not part of the project pipeline or workflow.
