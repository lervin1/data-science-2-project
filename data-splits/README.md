## Overview

This folder includes the saved out initial split of the data, as well as the testing, training and folds data used for the machine learning process. While initially setting up for this project, I conducted an initial split of the data with a proportion of 0.8 as well as stratified my target variable to account for the imbalance within the argument of the variable. I then used the `hotel_split` data to create the testing (`hotel_test`) and training (`hotel_train`) data. I then used the testing data to use cross validation to create `hotel_folds`. This is a crucial part as we use this for the numerous different models we tackle in this project. All of these are ultimately saved out to this subdirectory.

## References

[Hotel Booking Demand Dataset](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand/data)
