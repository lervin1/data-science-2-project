# Final Project 2 ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# reading in data ----
load(here("data/hotel_bookings_new.rda"))

# setting a seed ----

set.seed(20243012)

# initial split of data
hotel_split <- hotel_bookings_new |>
  initial_split(prop = 0.8, strata = is_canceled)

# verify each resulting dataframe has the correct number of columns and rows
hotel_train <- hotel_split |> training()
hotel_test <- hotel_split |> testing()

# cross validation
hotel_folds <- vfold_cv(hotel_train, v = 10, repeats = 6,
                        strata = is_canceled)

# save out files ----
save(hotel_split, file = here("data-splits/hotel_split.rda"))
save(hotel_train, file = here("data-splits/hotel_train.rda"))
save(hotel_test, file = here("data-splits/hotel_test.rda"))
save(hotel_folds, file = here("data-splits/hotel_folds.rda"))
