#################### Header Start ####################
# Title : Execution entry point for the project pipeline
# Author: Jing Liao
# Date created : 29/04/2026
# Date modified: 29/04/2026
# Context      :
# This script is to execute the whole project to get a final report
#################### Header End   ####################

# openReport = TRUE, a report will pop up
# openReport = FALSE, no report will show up but the entire project is executed for non-reporting purpose, e.g. update data or debugging etc.

run_all <- function(openReport = TRUE){
  
  # required library
  library(targets)
  library(here)
  
  # execute the entire project
  tar_make()
  
  # demonstrate the report directly
  if(isTRUE(openReport)){
    
    report_path <- here("report", "decision_report.html")
    
    if(file.exists(report_path)){
      
      browseURL(report_path)
      
    } else {
      
      message("Report not found. Please check if tar_make() completed successfully.")
      
    }
  }
}