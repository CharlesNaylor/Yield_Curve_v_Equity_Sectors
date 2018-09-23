# Measuring the Impact of Yield Curve Changes on Equity Sectors

I am comparing 60 years of data on the US Yield Curve to French's 49 Equity Sector return data. I fit several models to measure this impact:
  1. Simple OLS on separate sectors
  2. Quantile Regression on separate sectors
  3. Hierarchical Regression with missing data imputation

The last model uses partial pooling to ensure we don't ignore the similarities between equity sectors, and uses missing data imputation so that we can include data from the 60's and 70's in the data set. I felt the latter point was particularly important as there have been very few periods since then that the long-run yield curve has been inverted.

The hierarchical regression had to be limited to only 5 sectors as I lacked the processing power to run the full 49-sector version. The newest version of Stan has implemented map-reduce, at long last, so with access to a suitable machine, we could run the full set. Given that the quantile regression turned up some interesting behavior in the mid-range curve (10Y2Y spreads), it would probably be worth it to fit the hierarchical model as a quantile regression, as well.

## Notable Files

  -* [preprocessing.R](https://github.com/CharlesNaylor/Yield_Curve_v_Equity_Sectors/blob/master/preprocessing.R) - contains the script to turn raw downloaded data into tidy format
  - `.RData` - pre-calculated model fits. Some of the HMC-based models can take several hours to fit, and run into hundreds of megabytes due to the need to fit missing data. This saves the presentation from re-calculating that data each time it is run.
  -*** [Impact of Yield Curves on Equity Sectors - Preprocessing and Modeling](https://github.com/CharlesNaylor/Yield_Curve_v_Equity_Sectors/blob/master/Impact_of_Yield_Curves_on_Equity_Sectors_-_Preprocessing_and_Modeling.pdf) - Where the work got done. The rendered pdf gives details of the models I fit and my reasoning behind them.
  - [dashboard.Rmd](https://github.com/CharlesNaylor/Yield_Curve_v_Equity_Sectors/blob/master/dashboard.Rmd) - Code to render a live dashbord with which to examine the models.
