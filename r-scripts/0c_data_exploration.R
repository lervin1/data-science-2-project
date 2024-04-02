# Final Project 2 ----
# Data exploration for final project

## load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# load in training data ----
load(here("data-splits/hotel_train.rda"))
load(here("data/hotel_bookings_new.rda"))

# DATA EXPLORATION ----
# creating bar plot for target variable using whole dataset
fig_1 <- hotel_bookings_new |> 
  ggplot(aes(x = is_canceled)) +
  geom_bar(fill = "slategray2", color = "black") +
  theme_light() +
  labs(x = "Cancelled Booking",
       y = "Count")
# ggsave
ggsave(filename = "figures/fig_1.png", fig_1, width = 6, height = 4)

# creating bar plot for target variable using training data
hotel_train |> 
  ggplot(aes(x = is_canceled)) +
  geom_bar(fill = "slategray2", color = "black") +
  theme_light()

# looking at numeric variables
# correlation matrix
hotel_train |> 
  select(-days_in_waiting_list) |> 
  select_if(is.numeric) |> 
  na.omit() |> 
  cor() |> 
  corrplot::corrplot(method = 'color', diag = TRUE, 
                     type = "lower", tl.cex = 0.7, 
                     tl.col ="black")

# will do step_interact with...
# cancel_rate & previous_bookings_not_canceled
# adults & lead_time
# cancel_rate & lead_time


# looking at categorical variables to see which ones should be included
# in complex recipe
# looking at arrival date (month)
fig_3 <- hotel_train |>
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~arrival_date_month) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# seems to have a lot of variation, will include in recipe
# ggsave
ggsave(filename = "figures/fig_3.png", fig_3, width = 6, height = 4)


# looking at market segment
fig_4 <- hotel_train |>
  filter(market_segment != "Undefined") |> 
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~market_segment) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# will use in recipe
# ggsave
ggsave(filename = "figures/fig_4.png", fig_4, width = 6, height = 4)

# deposit type
fig_5 <- hotel_train |>
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~deposit_type) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# interesting to see that there were more cancellations when there was no refund
# kind of strange
# ggsave
ggsave(filename = "figures/fig_5.png", fig_5, width = 6, height = 4)

# room match
fig_24 <- hotel_train |>
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~room_match) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# will not use in recipe
# ggsave
ggsave(filename = "figures/fig_24.png", fig_24, width = 6, height = 4)

# customer type
fig_25 <- hotel_train |>
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~customer_type) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# do not need in recipe
# ggsave
ggsave(filename = "figures/fig_25.png", fig_25, width = 6, height = 4)

# type of hotel
fig_6 <- hotel_train |>
  ggplot(aes(x = is_canceled)) + 
  geom_bar(fill = "slategray2", color = "black") +
  facet_wrap(~hotel) +
  theme_light() +
  labs(x = "Cancelled Booking", y = "Count")
# interesting, will include in recipe
# ggsave
ggsave(filename = "figures/fig_6.png", fig_6, width = 6, height = 4)
