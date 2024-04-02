# Final Project 2 ----
# Define and fit baseline model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load folds data
load(here("data-splits/hotel_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hotel_basic_recipe.rda"))

# model specifications ----

null_mod <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("classification")

# define workflows ----
null_wflow <- workflow() |> 
  add_model(null_mod) |> 
  add_recipe(hotel_basic_recipe)


# fit workflows/models ----
null_fit <- fit_resamples(null_wflow, 
                          resamples = hotel_folds, 
                          control = control_resamples(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
null_results <- null_fit |> 
  collect_metrics()

save(null_results, file = here("results/null_results.rda"))
save(null_fit, file = here("results/null_fit.rda"))
