## Overview

This subdirectory includes the recipes used for our numerous different models. First, we have our `hotel_basic_recipe` which is essentially our "kitchen sink" recipe that includes all of the predictor variables of our dataset, except for the ones that have a direct correlation with our target variable. Next, we have our `hotel_basic_tree_recipe` which is essentially the same recipe as `hotel_basic_recipe`, expect altered to run with tree-based models. 

We then get into our recipes that were created as a result from our short EDA, therefore are more data driven. the `hotel_complex_recipe` includes only 8 predictor variables that I thought would be useful to include based on the short EDA I conducted. I also added interaction terms and "othered" variables to make it more complex. The `hotel_complex_tree_recipe` is a variation of the `hotel_complex_recipe`, and is altered to work with tree-based models.

## References

[Hotel Booking Demand Dataset](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand/data)