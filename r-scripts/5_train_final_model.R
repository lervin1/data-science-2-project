# Final Project 2 ----
# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data and rf tuned
load(here("results/btree_tuned_1.rda"))
load(here("data-splits/hotel_train.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# finalize workflow
final_wflow <- btree_tuned_1 |> 
  extract_workflow(btree_tuned_1) |>  
  finalize_workflow(select_best(btree_tuned_1, metric = "roc_auc"))

# train final model ----
# set seed
set.seed(20243012)
final_fit <- fit(final_wflow, hotel_train)

# save out final fit
save(final_fit, file = here("results/final_fit.rda"))
save(final_wflow, file = here("results/final_wflow.rda"))