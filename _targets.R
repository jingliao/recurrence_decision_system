
#################### Header Start ####################
# Title : targets
# Author: Jing Liao
# Date created : 28/03/2026
# Date modified: 28/04/2026
#################### Header End   ####################

# load packages
source("R/load_packages.R")

# required packages for runtime inside nodes
tar_option_set(
  packages = c("dplyr", "tidyr", "ggplot2", "purrr", "lubridate", "tibble"),
  format = "rds" # to produce .qmd if run tar_make() in the console
)

# source functions
source("R/load_packages.R")
source("R/simulate_data.R")
source("R/feature_engineering.R")
source("R/model.R")
source("R/validation.R")
source("R/decision.R")

# defining dependencies between targets(nodes)

list(
  tar_target(sim_data, func_simulate_events()),
  tar_target(df_features, func_create_features(sim_data)),
  tar_target(model_fit_cont, func_fit_model_episode(df_features, TRUE)),
  tar_target(model_fit_cate, func_fit_model_episode(df_features, FALSE)),
  tar_target(prediction_cont, func_add_prediction(df_features, model_fit_cont)),
  tar_target(prediction_cate, func_add_prediction(df_features, model_fit_cate)),
  tar_target(evaluate_cont, func_evaluate_model(prediction_cont)),
  tar_target(evaluate_cate, func_evaluate_model(prediction_cate)),
  tar_target(validation_cont, func_run_validation_checks(prediction_cont)),
  tar_target(validation_cate, func_run_validation_checks(prediction_cate)),
  tar_target(decision_output_cont, func_create_decision_output(prediction_cont)),
  tar_target(decision_output_cate, func_create_decision_output(prediction_cate)),
  tar_quarto(report, "report/decision_report.qmd")
)
