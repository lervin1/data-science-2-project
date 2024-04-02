# Final Project 2 ----
# Define and fit second logistic model

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
logistic_spec <- 
  logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification") 

# define workflows ----
logistic_wflow_2 <- workflow() |>
  add_model(logistic_spec) |>
  add_recipe(hotel_complex_recipe)

# fit workflows/models ----
fit_logistic_2 <- fit_resamples(logistic_wflow_2, resamples = hotel_folds, 
                              control = control_resamples(save_pred = TRUE))


# view results
logistic_results_2 <- fit_logistic_2 |> collect_metrics()

# write out results (fitted/trained workflows) ----
save(logistic_results_2, file = here("results/logistic_results_2.rda"))
save(fit_logistic_2, file = here("results/fit_logistic_2.rda"))
save(logistic_wflow_2, file = here("results/logistic_wflow_2.rda"))