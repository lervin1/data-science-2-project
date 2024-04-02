# Final Project 2 ----
# Define and tune second elastic net model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data-splits/hotel_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hotel_complex_recipe.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# model specifications ----
en_model <- logistic_reg(penalty = tune(), mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

# updating hyperparameters
en_params <- extract_parameter_set_dials(en_model) |> 
  update(mixture = mixture(c(0,1)))

en_grid <- grid_regular(en_params, levels = 3)

# define workflows ----
en_wflow_2 <- workflow() |> 
  add_model(en_model) |> 
  add_recipe(hotel_complex_recipe)

# fit workflows/models ----
# set seed
set.seed(20243012)
# tune model
en_tuned_2 <-
  en_wflow_2 |> 
  tune_grid(
    hotel_folds, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# view results
en_results_2 <- en_tuned_2 |> collect_metrics()

# write out results (fitted/trained workflows) ----
save(en_wflow_2, file = here("results/en_wflow_2.rda"))
save(en_tuned_2, file = here("results/en_tuned_2.rda"))
save(en_results_2, file = here("results/en_results_2.rda"))