# Time_Series_Analysis-with-Bootstrap
This is my algorithm and R syntax for predicting rice price using ARIMA with Bootstrap Residual

- Install/import the packages
- Read the data (Make sure the data have same format as my example)
- Transform the data into time series
- Check its stationarity in variance
- If it hasn't stationar, transform the series with Box Cox Transformation.
- Check its stationarity in mean with Augmented Dickey Fuller (ADF) test.
- If it hasn't stationar, difference the series.
- Plot the Autocorrelation Function (ACF) and Partial Autocorrelation Function (PACF)
- Define the ordo (p,d,q) and make the ARIMA(p,d,q) model.
- Check its assumtion of normality and white noise. Check its error (MAPE). 
- Choose the best model
- If the model residual isn't normal distributed, do the bootstrap
- Sample the residual with replacement. Define the new data Z*=Z+e* where Z*: New data, Z: Data before sampling, and e*: residual after sampling. Make the ARIMA(p,d,q) model with the new data (Z*) and save its parameter. Iterate it B times for n<B<n^n
- Define the parameter (phi and theta) with the bootstrap parameter's average.
- Forecast with the new bootstrap parameter and validate it with data test
