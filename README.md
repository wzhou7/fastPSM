# What is `fastPSM`?

Given a binary classfication problem, `fastPSM` attempts to automatically search for the best predictive model that will output for each case the propensity scores. 

Features of the `fastPSM` package are:
* Will attempt a wide selection of base models: logistic regression, classification trees, support vector machines, naive Bayes, artificial neural networks, and auto-ml
* Automatic cross validate and select models

# How to Install This Package?

To use this package, you will need the devtools library to install it from github:

```
library(devtools)
install_github("wzhou7/fastPSM") # install package from Github
```

The above code needs to be run just once for any given computer. Then, you can load the package each time you are ready to use it:

```
library(fastPSM) # load package
```

# How to Conduct Analysis with `fastPSM`?

The following code will conduct all the training and model selection automatrically:

```
results <- fastPSM(Y~., data=df)
```

Then you can use the modeling output to do several things. For example

```
# obtain propensity scores for training samples
Y_train_pred <- predict(results$best_model, X_train) 

# obtain propensity scores for new samples
Y_test_pred <- predict(results$best_model, X_test) 
```

Follow our [example study](docs/example.md) for more details. 

