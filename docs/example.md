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