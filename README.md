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
The `tfDID` package requires two input data frames.  

The T1 data, `data_T1`, should have variables \[`ID`, `Z1`, `Z2`, ..., `Zq`, `Y`, `X1`, `X2`, ..., `Xp`, \], where 
* `ID` is the sample identifier;
* `Z1`, `Z2`, ..., `Zp` are time-varying variables observed at T1
* `Y` is the dependent variable observed at T1
* `X1`, `X2`, ..., `Xp` are features observed at T1 that may be associated with the treatment status

The T2 data, `data_T2`, should have variables \[`ID`, `Z1`, `Z2`, ..., `Zq`, `Y`, `T` \]
* `ID` is the sample identifier;
* `Z1`, `Z2`, ..., `Zp` are time-varying variables observed at T2
* `Y` is the dependent variable at T2
* `T` is the treatment indicator

Then, you may run the following function:

```
PSM_DID(data_T1, data_T2, "out_path/report_file_name")
```

which will produce a report in HTML format in your specified path.

Follow our [example study](docs/example.md) for more details. 

