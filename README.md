# What is `tfDID`?

This package supports the testing of various difference-in-difference (DID) hypotheses based on an observed treatment variable. Due to self-selection bias, we include a propensity score matching (PSM) step. A unique aspect is that the treatment variables could be extracted from text.

# How to Use This Package?

To use this package, you will need the devtools library to install it from github. For example,

> install.packages("devtools") # install devtools
> library(devtools) # load devtools
> install_github("wzhou7/tfDID") # install package from Github

The above code needs to be run just once for any given computer. Then, you can load the package each time you are ready to use it:

> library(tfDID) # load package

Then follow our [example study](test_update/overview.md) to conduct your own PSM+DID study. 

