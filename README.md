# What is `tfDID`?

This package supports the testing of various text feature difference-in-difference (tfDID) analysis. 

# How to Install This Package?

To use this package, you will need the devtools library to install it from github. For example,

```
install.packages("devtools") # install devtools
library(devtools) # load devtools
install_github("wzhou7/tfDID") # install package from Github
```

The above code needs to be run just once for any given computer. Then, you can load the package each time you are ready to use it:

```
library(tfDID) # load package
```

# How to Conduct Analysis with `tfDID`?

In a typical DID setting, there are two time points, `T1` and `T2`, at which an observation is taken about given samples.
The `tfDID` package requires two input data frames.  

The T1 data should have \[`ID`, `X1`, `X2`, ..., `Xp`, `Y` \], where 
* `ID` is the sample identifier;
* `X1`, `X2`, ..., `Xp` are features observed at T1
* `Y` is the dependent variable at T1

The T2 data should have \[`ID`, `T`, `Y` \]
* `ID` is the sample identifier;
* `X1`, `X2`, ..., `Xp` are features observed at T1
* `Y` is the dependent variable at T1

Then follow our [example study](test_update/overview.md) to conduct your own PSM+DID study. 

