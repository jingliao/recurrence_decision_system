# Recurrence decision system

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


