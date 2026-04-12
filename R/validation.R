
# check required columns in the data

func_check_required_columns <- function(param_df, param_cols){
  
  # find columns not are not in the data
  missing_cols <- setdiff(param_cols, names(param_df))
  
  tibble::tibble(check = "required_columns",
                 passed = length(missing_cols) == 0,
                 details = if(length(missing_cols) == 0){
                   "All required columns are present"
                   } else {
                     paste("Missing columns:", paste(missing_cols, collapse = ", "))
                     }
                 ) 
}

# check missing values in the data

func_check_missing_values <- function(param_df, param_cols) {
  
  # total number of missing values in designated columns
  missing_n <- sum(is.na(param_df[, param_cols])) 
  
  tibble::tibble(check = "missing_values",
                 passed = missing_n == 0,
                 details = paste("Total missing values across columns of interest:", missing_n)
                 )
}


# check logic of the predicted probability range

func_check_pred_prob_ranges <- function(param_df, param_col = "pred_prob"){
  
  bad_n <- sum(is.na(param_df[[param_col]]) | param_df[[param_col]] < 0 | param_df[[param_col]] > 1) 
  
  tibble::tibble(check = "range_predicted_probability",
                 passed = bad_n == 0,
                 details = paste("Number of invalid predicted probabilities either out of (0,1) or NA:", bad_n)
                 )
  
}

# check the output of predicted class, it should be 0 or 1

func_check_pred_class_values <- function(param_df, param_col = "pred_class"){
  
  bad_n = sum(!param_df[[param_col]] %in% c(0, 1))
  tibble::tibble(check = "values_predicted_class",
                 passed = bad_n == 0,
                 details = paste("Number of invalid predicted classes:", "bad_n")
                 )
}

# check the output of risk level only consisting of low, medium or high

func_check_risk_level_values <- function(param_df, param_col = "risk_level"){
  
  bad_n <- sum(!param_df[[param_col]] %in% c("low", "medium", "high"))
  
  tibble::tibble(check = "values_risk_level",
                 passed = bad_n == 0,
                 details = paste("Number of invalid risk levels:", bad_n)
                 )
  
}

# combine and display in a table

func_run_validation_checks <- function(param_df){
  
  dplyr::bind_rows(func_check_required_columns(param_df, 
                                               param_cols = c("risk_level", "y_recur_within_180",
                                                              "pred_prob", "pred_class")),
                   func_check_missing_values(param_df,
                                             param_cols = c("risk_level", "y_recur_within_180",
                                                            "pred_prob", "pred_class")),
                   func_check_pred_prob_ranges(param_df, param_col = "pred_prob"),
                   func_check_pred_class_values(param_df, param_col = "pred_class"),
                   func_check_risk_level_values(param_df, param_col = "risk_level")
  )
}
