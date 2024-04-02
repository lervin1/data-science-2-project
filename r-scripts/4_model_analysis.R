# Final Project 2 ----
# Analysis of tuned and trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(knitr)

# handle common conflicts
tidymodels_prefer()

# load fit/tuned models
load(here("results/btree_tuned_1.rda"))
load(here("results/btree_tuned_2.rda"))
load(here("results/en_tuned_1.rda"))
load(here("results/en_tuned_2.rda"))
load(here("results/fit_logistic_1.rda"))
load(here("results/fit_logistic_2.rda"))
load(here("results/knn_tuned_1.rda"))
load(here("results/knn_tuned_2.rda"))
load(here("results/null_fit.rda"))
load(here("results/rf_tuned_1.rda"))
load(here("results/rf_tuned_2.rda"))

# load testing data
load(here("data-splits/hotel_test.rda"))

# visual inspection using autoplot ----
# boosted tree
auto_7 <- autoplot(btree_tuned_1, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_7.png", auto_7, width = 7, height = 6)

auto_8 <- autoplot(btree_tuned_2, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_8.png", auto_8, width = 7, height = 6)

# elastic net
auto_1 <- autoplot(en_tuned_1, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_1.png", auto_1, width = 6, height = 4)

auto_2 <- autoplot(en_tuned_2, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_2.png", auto_2, width = 6, height = 4)

# k-nearest neighbor
auto_3 <- autoplot(knn_tuned_1, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_3.png", auto_3, width = 6, height = 4)

auto_4 <- autoplot(knn_tuned_2, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_4.png", auto_4, width = 6, height = 4)

# random forest
auto_5 <- autoplot(rf_tuned_1, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_5.png", auto_5, width = 6, height = 4)

auto_6 <- autoplot(rf_tuned_2, metric = "roc_auc") +
  ylab("ROC AUC")
# ggsave
ggsave(filename = "figures/auto_6.png", auto_6, width = 6, height = 4)

# select best ----
# boosted tree
select_best(btree_tuned_1, metric = "roc_auc")
select_best(btree_tuned_2, metric = "roc_auc")

# elastic net
select_best(en_tuned_1, metric = "roc_auc")
select_best(en_tuned_2, metric = "roc_auc")

# k-nearest neighbor
select_best(knn_tuned_1, metric = "roc_auc")
select_best(knn_tuned_2, metric = "roc_auc")

# random forest
select_best(rf_tuned_1, metric = "roc_auc")
select_best(rf_tuned_2, metric = "roc_auc")

# creating table to see best models ----
# boosted tree
tbl_btree_1 <- btree_tuned_1 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree")

tbl_btree_2 <- btree_tuned_2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Boosted Tree")

# elastic net
tbl_en_1 <- en_tuned_1 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Elastic Net")

tbl_en_2 <- en_tuned_2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Elastic Net")

# k-nearest neighbor
tbl_knn_1 <- knn_tuned_1 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K-Nearest Neighbor")

tbl_knn_2 <- knn_tuned_2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K-Nearest Neighbor")

# random forest
tbl_rf_1 <- rf_tuned_1 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest")

tbl_rf_2 <- rf_tuned_2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest")

# logistic 
tbl_logistic_1 <- fit_logistic_1 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic")

tbl_logistic_2 <- fit_logistic_2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Logistic")

# null
tbl_null <- null_fit |> 
  show_best("roc_auc") |> 
  slice_max(mean) |>
  slice_head(n = 1) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Null")

# creating results tables
results_table_1 <- bind_rows(tbl_null, tbl_logistic_1, tbl_rf_1, tbl_knn_1,
                             tbl_en_1, tbl_btree_1) |> 
  select(model, mean, std_err, n) |> 
  arrange(desc(mean)) |> 
  rename("Mean ROC AUC" = mean,
         "Model" = model,
         "Standard Error" = std_err,
         "N" = n) |> 
  kable()

results_table_1

results_table_2 <- bind_rows(tbl_null, tbl_logistic_2, tbl_rf_2, tbl_knn_2,
                             tbl_en_2, tbl_btree_2) |> 
  select(model, mean, std_err, n) |> 
  arrange(desc(mean)) |> 
  rename("Mean ROC AUC" = mean,
         "Model" = model,
         "Standard Error" = std_err,
         "N" = n) |> 
  kable()

results_table_2

# save results tables
save(results_table_1, file = here("results/results_table_1.rda"))
save(results_table_2, file = here("results/results_table_2.rda"))