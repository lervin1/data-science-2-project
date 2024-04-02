# Final Project 2 ----
# Data cleaning/wrangling for final project

# load packages
library(tidyverse)
library(tidymodels)
library(naniar)

## looking for na values and changing variables to factor
hotel_bookings_new <- hotel_bookings |> 
  mutate(company = na_if(as.character(company), "NULL"),
         agent = na_if(as.character(agent), "NULL"),
         country = na_if(as.character(country), "NULL"))

missing_count <- colSums(is.na(hotel_bookings_new))
knitr::kable(missing_count, col.names = c("Variable", "Count Missing"))
miss_sum <- miss_var_summary(hotel_bookings_new) |> 
  slice_head(n = 3) |> 
  kable()

gg_miss_var(hotel_bookings_new)

# save table
save(miss_sum, file = here("results/miss_sum.rda"))


## creating new variables for recipes
hotel_bookings_new <- hotel_bookings_new |>
  mutate(tot_book = previous_cancellations + previous_bookings_not_canceled,
         cancel_rate = previous_cancellations/tot_book,
         room_match = reserved_room_type == assigned_room_type,
         minors = children + babies)

## creating factor variables
hotel_bookings_new <- hotel_bookings_new |> 
  mutate(is_canceled = factor(is_canceled),
         hotel = factor(hotel),
         meal = factor(meal),
         market_segment = factor(market_segment),
         distribution_channel = factor(distribution_channel),
         is_repeated_guest = factor(is_repeated_guest),
         reserved_room_type = factor(reserved_room_type),
         assigned_room_type = factor(assigned_room_type),
         booking_changes = factor(booking_changes),
         deposit_type = factor(deposit_type),
         customer_type = factor(customer_type),
         reservation_status = factor(reservation_status),
         room_match = factor(room_match),
         arrival_date_year = factor(arrival_date_year),
         arrival_date_month = factor(arrival_date_month)) |> 
  select(-c(arrival_date_week_number, arrival_date_day_of_month,
            reservation_status_date, country, agent, company))

# only looking at arrival dates from 2015 
hotel_bookings_new <- hotel_bookings_new |> 
  filter(arrival_date_year == 2015)

# saving new hotel data ----
save(hotel_bookings_new, file = here("data/hotel_bookings_new.rda"))