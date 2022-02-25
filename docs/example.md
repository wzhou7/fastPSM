# AppStore Apps

Can an update help a mobile app improve user engagement? To answer this question, we want to predict **whether an app will be updated between T1 and T2** using apps' T1 features. 

## Data Preparation

The user provides the following input

* `Y` is the binary target variable, represented as a vector of length n. No missing value allowed. In our case, it is a binary indicator of whether an app was updated between T1 and T2.
* `X` is the input feature matrix, represented as a n-by-p data frame. 
* `X0=c(v1,v2)` are the base features at T1, such as IsFree and Categories. These are the features to be used in all 4 partitions.
* `X1=c(v3)` are features related to the most recent update prior to T1, such as DaysSinceUpdate. Some apps have not yet been updated, so features related to the previous update will be missing.
* `X2=c(v4,v5,v6)` are features related to ratings information prior to T1, such as average rating for current version. Many apps do not have a rating, so features like the average rating will be a missing value.

`X0`, `X1`, and `X2` are data frames with $n$ rows. Rows at the same index (along with `Y`) correspond to the same case. 

Once the data are loaded, one can run the following code:

```
modeling_results <- fastPSM(Y, X, X0, X1, X2)
```

The returned results include

* The best model
* All models tried, along with their parameters and performance metrics
* ROC curve to compare the models

## What `fastPSM` Does

* First, all $n$ cases (identified by rows) are split into 4 subsets: `S00`, `S01`, `S10`, `S11` depending on availability of `X1` and `X2` features.
  - impute the small number of missing values in `X1` and `X2` when applicable
* Then, we attempt to fit a separate model per subset by going though the following process:
  - Split train test by default ratio of 80:20
  - With a chosen method, tune parameter by holdout validation. Currently, we implemented
  (1) Single rpart;
  (2) Hybrid rpart;
  (3) Hybrid Logistic.
  - Return the final model with chosen parameter
