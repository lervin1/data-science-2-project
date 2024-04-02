# Final Project 2 ----
# Define and tune first elastic net model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data-splits/hotel_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hotel_basic_recipe.rda"))

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doParallel::registerDoParallel(cores = num_cores)

# model specifications ----
en_model <- logistic_reg(penalty = tune(), mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

# hyperparameter tuning values ----
en_params <- extract_parameter_set_dials(en_model) |> 
  update(mixture = mixture(c(0,1)))

en_grid <- grid_regular(en_params, levels = 3)

# define workflows ----
en_wflow_1 <- workflow() |> 
  add_model(en_model) |> 
  add_recipe(hotel_basic_recipe)

# fit workflows/models ----
# set seed
set.seed(20243012)
# tune model
en_tuned_1 <-
  en_wflow_1 |> 
  tune_grid(
    hotel_folds, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# view results
en_results_1 <- en_tuned_1 |> collect_metrics()

# write out results (fitted/trained workflows) ----
save(en_wflow_1, file = here("results/en_wflow_1.rda"))
save(en_tuned_1, file = here("results/en_tuned_1.rda"))
save(en_results_1, file = here("results/en_results_1.rda"))
