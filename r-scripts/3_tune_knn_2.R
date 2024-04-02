# Final Project 2 ----
# Define and tune second nearest neighbor model

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

# set seed
set.seed(20243012)

# model specifications ----
knn_mod <- nearest_neighbor(neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("classification")

# define workflows ----
knn_wflow_2 <- workflow() |> 
  add_model(knn_mod) |> 
  add_recipe(hotel_complex_tree_recipe)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_mod)

# change hyperparameter ranges
knn_params <- parameters(knn_mod)

# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(20243012)
# tune model
knn_tuned_2 <- 
  knn_wflow_2 |> 
  tune_grid(
    hotel_folds, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# looking at results
knn_results_2 <- knn_tuned_2 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(knn_wflow_2, file = here("results/knn_wflow_2.rda"))
save(knn_tuned_2, file = here("results/knn_tuned_2.rda"))
save(knn_results_2, file = here("results/knn_results_2.rda"))