# Final Project 2 ----
# Define and fit first logistic model

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
logistic_spec <- 
  logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification") 

# define workflows ----
logistic_wflow_1 <- workflow() |>
  add_model(logistic_spec) |>
  add_recipe(hotel_basic_recipe)

# fit workflows/models ----
fit_logistic_1 <- fit_resamples(logistic_wflow_1, resamples = hotel_folds, 
                              control = control_resamples(save_pred = TRUE))


# view results
logistic_results_1 <- fit_logistic_1 |> collect_metrics()

# write out results (fitted/trained workflows) ----
save(logistic_results_1, file = here("results/logistic_results_1.rda"))
save(logistic_wflow_1, file = here("results/logistic_wflow_1.rda"))
save(fit_logistic_1, file = here("results/fit_logistic_1.rda"))