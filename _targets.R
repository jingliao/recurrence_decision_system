# required packages
library(targets)
#library(tarchetypes)

# required packages for runtime inside nodes
tar_option_set(
  packages = c("dplyr", "tidyr", "ggplot2", "purrr", "lubridate", "tibble")
)

# source functions
source("R/simulate_data.R")
source("R/feature_engineering.R")
source("R/model.R")

# defining dependencies between targets(nodes)

list(
  tar_target(sim_data, simulate_events()),
  tar_target(df_features, create_features(sim_data)),
  tar_target(model_fit_cont, fit_model_continuous(df_features)),
  tar_target(model_fit_cate, fit_model_categorical(df_features)),
  tar_target(prediction_cont, add_prediction(df_features, model_fit_cont)),
  tar_target(prediction_cate, add_prediction(df_features, model_fit_cate)),
  tar_target(evaluate_cont, evaluate_model(prediction_cont)),
  tar_target(evaluate_cate, evaluate_model(prediction_cate))
)

# execution part ONLY can be conducted in Console, DO NOT comment out in this file!
# tar_read(sim_person)
# tar_make(names = c("episodes", "report_episode")) # this will only run episodes part in the report
# tar_make(names = "report_episode")

# to check the data:
# tar_make(names = object_of_interest)
# tar_read(object_of_interest) |> head()
# tar_make(names = c("person_features", "model_fit", "report_model"))
# tar_make(names = "person_features")
# tar_read(person_features) |> names()
# tar_make(names = "ds_prediction")
# tar_read(ds_prediction) |> head()
# tar_visnetwork()
# tar_make(names = "report_prediction")
