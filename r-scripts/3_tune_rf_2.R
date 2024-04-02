# Final project 2 ----
# Define and fit random forest model with basic tree recipe
# random process used in the script

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load folds data
load(here("data-splits/hotel_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hotel_complex_tree_recipe.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# model specifications ----
rf_mod <-
  rand_forest(trees = 1000,
              min_n = tune(),
              mtry = tune()) |> 
  set_engine("ranger", importance = "impurity") |> 
  set_mode("classification")

# define workflows ----
# using basic tree recipe
rf_wflow_2 <- workflow() |> 
  add_model(rf_mod) |> 
  add_recipe(hotel_complex_tree_recipe)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_mod)

# change hyperparameter ranges
rf_params_2 <- parameters(rf_mod) |> 
  update(mtry = mtry(c(1, 5))) 

# build tuning grid
rf_grid_2 <- grid_regular(rf_params_2, levels = 5)

# fit workflows/models ----
# set seed
set.seed(20243012)
# tune model
rf_tuned_2 <- 
  rf_wflow_2 |> 
  tune_grid(
    hotel_folds, 
    grid = rf_grid_2, 
    control = control_grid(save_workflow = TRUE)
  )

# looking at results
rf_results_2 <- rf_tuned_2 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(rf_wflow_2, file = here("results/rf_wflow_2.rda"))
save(rf_tuned_2, file = here("results/rf_tuned_2.rda"))
save(rf_results_2, file = here("results/rf_results_2.rda"))