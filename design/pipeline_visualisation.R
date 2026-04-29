#################### Header Start ####################
# Title : Pipeline visualisation using Directed Acyclic Graph (DAG)
# Author: Jing Liao
# Date created : 29/04/2026
# Date modified: 29/04/2026
# Context      :
# This script is independent from the project structure. 
# It aims to demonstrate the pipeline design for the project.
#################### Header End   ####################

# [0.0] requiredd packages ----

library(targets)
library(htmlwidgets)

vis_graph <- tar_visnetwork()

saveWidget(vis_graph, 
           "design/DAG.html", 
           selfcontained = TRUE)


