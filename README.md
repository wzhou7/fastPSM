# What is `fastPSM`?

Given a feature matrix `X` and the corresponding target variable `Y`, `fastPSM(X,Y)` attempts to automatically search for the best predictive model that will output for each case the propensity scores.

# How to Install This Package?

To use this package, you will need the devtools library to install it from github. 
When this repository is set as private, after setting up your credentials in RStudio, install this package as follows:

```
library(gitcreds)
library(devtools)
install_github("wzhou7/fastPSM", auth_token=gitcreds_get()$password) # install package from Github
```

The above code needs to be run just once for any given computer. Then, you can load the package each time you are ready to use it:

```
library(fastPSM) # load package
```

# How to Conduct Analysis with `fastPSM`?

The following code will conduct all the training and model selection automatrically:

```
modeling_results <- fastPSM(X_train, Y_train)
```

Then you can use the modeling output to do several things. For example

```
Y_train_pred <- predict(modeling_results$best_model, X_train) # obtain propensity scores for training samples
Y_test_pred <- predict(modeling_results$best_model, X_test) # obtain propensity scores for new samples
```

Follow our [example study](docs/example.md) for more details. 

