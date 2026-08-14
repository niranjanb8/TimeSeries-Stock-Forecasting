# Apple Stock Forecasting

This project explores Apple stock from a time-series perspective, studying temporal dependencies, seasonal patterns, and forecasting efforts using monthly-adjusted closing prices.

## Overview

Apple’s long financial history reflects decades of technological innovation, evolving investor expectations, and exposure to major macroeconomic events. These dynamics make its stock performance a compelling candidate for time-series analysis. This project investigates the temporal structure underlying Apple’s historical stock prices, with the goal of identifying patterns and evaluating statistical models for forecasting future performance.

## Methods

Exploratory Analysis: Initial EDA

ACF & PACF Analysis: Autocorrelation Structure Assessment

Model Fitting & Diagnostics: ARIMA & SARIMA Modeling

Model Selection: AIC, BIC, and AICc comparison

Heteroskedasticity Assessment: Conditional Variance Diagnostics

Volatility Modeling: ARCH + GARCH Modeling

Forecasting: Future-Month Prediction

Limitations: Modeling Limitations & Future Improvements

## Key Findings

- Identified initial ARIMA(1, 0, 0) time-series structure in historical Apple stock prices.
- Selected model based on AIC, BIC, AICc scores and residual diagnostics.
- Found evidence of conditional heteroskedasticity, motivating exploration of ARCH & GARCH modeling to capture changing volatility.
- Determined ARIMA(1, 0, 0) + GARCH(1, 1) time-series structure as final model.
- Forecasted Apple stock performance over a 20-month horizon

## Full Report & Code

The complete analysis is available in the [Full Project Report](./Time_Series_Final.pdf), while the underlying data can be found in the [Apple Stock Dataset](./Apple_Stock.csv). The raw code file can be found in the [Raw Code File](./Time_Series_Raw_Code.R).
