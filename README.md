# What is `fastPSM`?

Given a target variable `Y`, feature matrices `X0`, `X1`. and `X2`, `fastPSM(Y,X0,X1,X2)` attempts to automatically search for the best predictive model that will output for each case the propensity scores. 

Features of the `fastPSM` package are:
* Can fit separate models for features with lots of missing values or constants
* Will attempt a wide selection of base models
* Automatic cross validate and select models

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
modeling_results <- fastPSM(Y, X0, X1, X2)
```

Then you can use the modeling output to do several things. For example

```
Y_train_pred <- predict(modeling_results$best_model, X_train) # obtain propensity scores for training samples
Y_test_pred <- predict(modeling_results$best_model, X_test) # obtain propensity scores for new samples
```

Follow our [example study](docs/example.md) for more details. 

