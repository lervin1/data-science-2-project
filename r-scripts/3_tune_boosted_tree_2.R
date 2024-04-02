# Final Project 2 ----
# Define and fit second boosted tree model

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
btree_mod <- boost_tree(
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune(),
  trees = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

# define workflows ----
btree_wflow_2 <- workflow() |> 
  add_model(btree_mod) |> 
  add_recipe(hotel_complex_tree_recipe)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(btree_mod)

# change hyperparameter ranges
btree_params_2 <- hardhat::extract_parameter_set_dials(btree_mod) |> 
  update(mtry = mtry(c(1, 5)),
         learn_rate = learn_rate(range = c(-5, -0.2)),
         trees = trees(range = c(50, 500)))

# build tuning grid
btree_grid_2 <- grid_regular(btree_params_2, levels = c(5, 3, 4, 5))

# fit workflows/models ----
# set seed
set.seed(20243012)
# tune model
btree_tuned_2 <- 
  btree_wflow_2 |> 
  tune_grid(
    hotel_folds, 
    grid = btree_grid_2, 
    control = control_grid(save_workflow = TRUE)
  )

# looking at results
btree_results_2 <- btree_tuned_2 |> 
  collect_metrics()

# write out results (fitted/trained workflows) ----
save(btree_wflow_2, file = here("results/btree_wflow_2.rda"))
save(btree_tuned_2, file = here("results/btree_tuned_2.rda"))
save(btree_results_2, file = here("results/btree_results_2.rda"))