# Final Project 2 ----
# Setup pre-processing/recipes

## load packages ----

library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data-splits/hotel_train.rda"))

# creating basic recipe ----
hotel_basic_recipe <- recipe(is_canceled ~., data = hotel_train) |> 
  step_rm(reservation_status) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_mutate(tot_book = ifelse(tot_book > 0, 1, 0)) |> 
  step_mutate(minors = ifelse(minors > 0, 1, 0)) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())
  

# seeing if recipe works
prep(hotel_basic_recipe) |>
  bake(new_data = NULL) |> 
  view()

# creating tree based basic recipe ----
hotel_basic_tree_recipe <- recipe(is_canceled ~., data = hotel_train) |> 
  step_rm(reservation_status) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_mutate(tot_book = ifelse(tot_book > 0, 1, 0)) |> 
  step_mutate(minors = ifelse(minors > 0, 1, 0)) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE)

# seeing if recipe works
prep(hotel_basic_tree_recipe) |>
  bake(new_data = NULL) |> 
  view()


# creating complex recipe based on data exploration ----
hotel_complex_recipe <- recipe(is_canceled ~previous_bookings_not_canceled + 
                               arrival_date_month + market_segment +
                               deposit_type + hotel + cancel_rate + adults +
                               lead_time,
                               data = hotel_train) |>
  step_other(market_segment) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact(terms = ~cancel_rate:lead_time) |>
  step_interact(terms = ~cancel_rate:previous_bookings_not_canceled) |>
  step_interact(terms = ~adults:lead_time) |> 
  step_zv(all_predictors()) |>
  step_normalize(all_predictors())

# seeing if recipe works
prep(hotel_complex_recipe) |>
  bake(new_data = NULL) |>
  view()

# creating complex tree recipe based on data exploration ----
hotel_complex_tree_recipe <- recipe(is_canceled ~previous_bookings_not_canceled + 
                               arrival_date_month + market_segment +
                               deposit_type + hotel + cancel_rate + adults +
                               lead_time,
                               data = hotel_train) |>
  step_other(market_segment) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE)

# seeing if recipe works
prep(hotel_complex_tree_recipe) |>
  bake(new_data = NULL) |>
  view()

# save recipes ----
save(hotel_basic_recipe, file = here("recipes/hotel_basic_recipe.rda"))
save(hotel_basic_tree_recipe, file = here("recipes/hotel_basic_tree_recipe.rda"))
save(hotel_complex_recipe, file = here("recipes/hotel_complex_recipe.rda"))
save(hotel_complex_tree_recipe, file = here("recipes/hotel_complex_tree_recipe.rda"))