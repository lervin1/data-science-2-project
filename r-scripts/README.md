## Overview

This subdirectory includes all of the r-scipts used to formulate the cleaning, initial setup, recipes, tuning/fitting, analyses as well training and assessing the final model. 

First, we get into our r-scripts that are dedicated to the data collection, cleaning, and analyzing process. This is indicated with the number "0", as it is a precursor to the steps ahead. Next, we start with our initial setup r-script that performs the initial split of the data into testing and training, and well as creating the folds data through cross validation. Then, the recipes r-script is used to conduct, prep, and bake the recipes in order to use for the numerous different models we encounter.

We then get into all of our r-scripts that have to do with fitting and tuning our models. They are named with a "3" in front of it because it is the third step in our modeling process. We separate them into different r-scripts because they each have different tuning/fitting hyperparameters, as well as it helps us run the models smoothly with background jobs.

The next r-script is dedicated to the model analysis, and ultimately allows us to analyze the different models we conducted and pick our best model for our final fit. In this project, we saw that the best model was the boosted tree model with the basic tree recipe.

Once we uncovered our best model, we are able to train and assess our final model. This will ultimately be visualized through autoplots and confusion matrices found in the qmd and html documents.

This subdirectly also includes the r-script used to code the codebook.

## References

[Hotel Booking Demand Dataset](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand/data)