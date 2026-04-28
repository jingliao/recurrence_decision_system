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

## What it does

- Simulates event data with a controlled data-generating process
- Builds logistic regression models to predict recurrence
- Compares continuous vs. categorical feature representations
- Adds validation checks on prediction outputs
- Converts predictions into risk tiers and suggested actions
- Generates a Quarto report

## Workflow

simulate_data -> features -> model -> prediction -> validation -> decision -> report

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


