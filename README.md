# What is `tfDID`?

This package supports the testing of various text feature difference-in-difference (tfDID) analysis. 

# How to Install This Package?

To use this package, you will need the devtools library to install it from github. 
When this repository is set as private, after setting up your credentials in RStudio, install this package as follows:

```
library(gitcreds)
library(devtools)
install_github("wzhou7/tfDID", auth_token=gitcreds_get()$password) # install package from Github
```

The above code needs to be run just once for any given computer. Then, you can load the package each time you are ready to use it:

```
library(tfDID) # load package
```

# How to Conduct Analysis with `tfDID`?

In a typical DID setting, there are two time points, `T1` and `T2`, at which an observation is taken about given samples.

First, you may conduct just the first stage model to predict the propensity:

```
scores <- PROP(data_T1, id="AppID", target="Updated",
               predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
               method="wzhou4_logit_default",
               report="report_file_name")
```

Or you may conduct just the second stage model:

```
DID(data_T1, data_T2, "out_path/report_file_name")
```

You may run the following function:

```
PSM_DID(data_T1, data_T2, 
        id="AppID",
        dv="RateC_avg",
        iv="Updated",
        cvs=c(),
        report="report_file_name")
```

which will produce a report in HTML format in your specified path.

Follow our [example study](docs/example.md) for more details. 

