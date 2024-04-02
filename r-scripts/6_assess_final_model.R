# Final Project 2 ----
# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(knitr)

# handle common conflicts
tidymodels_prefer()

# load testing data and final fit
load(here("data-splits/hotel_test.rda"))
load(here("results/final_fit.rda"))

# roc auc ----
pred_prob_btree <- predict(final_fit, hotel_test, type = "prob")

bt_results_1 <- hotel_test |> 
  select(is_canceled) |> 
  bind_cols(pred_prob_btree)

roc_final <- roc_auc(bt_results_1, is_canceled, .pred_0)
btree_roc_curve <- roc_curve(prob_result_1, is_canceled, .pred_0)

# rocplot
auto_roc <- autoplot(btree_roc_curve)
# ggsave
ggsave(filename = "figures/auto_roc.png", auto_roc, width = 6, height = 4)

# accuracy ----
pred_class_btree <- predict(final_fit, hotel_test, type = "class")

bt_results_2 <- hotel_test |> 
  select(is_canceled) |> 
  bind_cols(pred_class_btree)

acc_final <- accuracy(bt_results_2, is_canceled, .pred_class)

# confusion matrix
conf_matrix <- conf_mat(btree_result, is_canceled, .pred_class)
as.data.frame.matrix(conf_matrix$table) |> kable()

# save conf matrix
save(conf_matrix, file = here("results/conf_matrix.rda"))
save(roc_final, file = here("results/roc_final.rda"))
save(acc_final, file = here("results/acc_final.rda"))
