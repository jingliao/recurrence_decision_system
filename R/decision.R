
# assign pred_prob to risk_tier
func_assign_risk_tier <- function(param_df, param_col = "pred_prob", param_cut_high = 0.7, param_cut_medium = 0.4){
  
  param_df |>
    mutate(risk_tier = case_when(.data[[param_col]] >= param_cut_high ~ "high",
                                 .data[[param_col]] >= param_cut_medium ~ "medium",
                                 TRUE ~ "low")
           )
}

# assign risk_tier to suggested_action
func_assign_suggested_action <- function(param_df, param_col = "risk_tier"){
  
  param_df |>
    mutate(suggested_action = case_when(.data[[param_col]] == "high" ~ "prioritise follow-up",
                                        .data[[param_col]] == "medium" ~ "monitor",
                                        .data[[param_col]] == "low" ~ "routine review",
                                        TRUE ~ "check")
           )
}

# create decision output
func_create_decision_output <- function(param_df, param_col_prob = "pred_prob", param_col_class = "pred_class"){
  
  param_df |>
    func_assign_risk_tier(param_col = param_col_prob) |>
    func_assign_suggested_action() |>
    dplyr::select(person_id, risk_level, y_recur_within_180,
                  dplyr::all_of(param_col_prob),
                  dplyr::all_of(param_col_class),
                  risk_tier,
                  suggested_action,
                  dplyr::everything())
  
}