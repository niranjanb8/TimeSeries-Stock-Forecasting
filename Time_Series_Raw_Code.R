
## Data Pre-Processing & Cleaning

library(astsa)
library(tidyverse)
library(xts)

apple_data <- read.csv("Apple_Stock.csv")

apple_data_final <- apple_data |> select(date, adj_close) |> slice(-1)

apple_data_final$adj_close <- as.numeric(apple_data_final$adj_close)

apple_data_final$date <- as.Date(apple_data_final$date)

apple_data_xts <- xts(apple_data_final["adj_close"], order.by = apple_data_final$date)

apple_data_quarterly <- apply.quarterly(apple_data_xts, FUN = last)

apple_data_monthly <- apply.monthly(apple_data_xts, FUN = last)

apple_data_ts <- ts(apple_data_quarterly, start = c(1980, 4), frequency = 4)

apple_data_month <- ts(apple_data_monthly, start = c(1980, 12), frequency = 12)



## Exploratory Analysis

tsplot(apple_data_month, main = "Monthly-Adjusted Closing Price vs. Time", 
       xlab = "Time", ylab = "Monthly-Adjusted Closing Price", col = "blue")

tsplot(diff(apple_data_month), main = 
         "Monthly-Adjusted Closing Price vs. Time (Differenced)", xlab = "Time", 
       ylab = "Monthly-Adjusted Closing Price", col = "blue")
tsplot(log(apple_data_month), main = 
         "Monthly-Adjusted Closing Price vs. Time (Logged)", xlab = "Time", 
       ylab = "Monthly-Adjusted Closing Price", col = "blue")
tsplot(diff(log(apple_data_month)), main = 
         "Monthly-Adjusted Closing Price vs. Time (Differenced & Logged)", 
       xlab = "Time", ylab = "Monthly-Adjusted Closing Price", col = "blue")




# ACF and PACF Analysis

apple_data_transformed <- diff(log(apple_data_month))

acf2(apple_data_transformed, main = "Transformed Data")




# Model Fitting & Diagnostics

par(mfrow = c(3, 1))
ar1_model <- sarima(apple_data_transformed, 1, 0, 0)
ar2_model <- sarima(apple_data_transformed, 2, 0, 0)
ar3_model <- sarima(apple_data_transformed, 3, 0, 0)

par(mfrow = c(3, 1))
ma1_model <- sarima(apple_data_transformed, 0, 0, 1)
ma2_model <- sarima(apple_data_transformed, 0, 0, 2)
ma3_model <- sarima(apple_data_transformed, 0, 0, 3)

arma1_model <- sarima(apple_data_transformed, 1, 0, 1)
arma2_model <- sarima(apple_data_transformed, 2, 0, 2)
arma21_model <- sarima(apple_data_transformed, 2, 0, 1)
arma12_model <- sarima(apple_data_transformed, 1, 0, 2)




# Model Selection

final_IC_result <- data.frame(rbind(ar1_model$ICs, ar2_model$ICs, ar3_model$ICs, 
                                    ma1_model$ICs, ma2_model$ICs, ma3_model$ICs, 
                                    arma1_model$ICs, arma2_model$ICs, 
                                    arma21_model$ICs, arma12_model$ICs))

rownames(final_IC_result) <- c("AR1 Model", "AR2 Model", "AR3 Model", 
                               "MA1 Model", "MA2 Model", "MA3 Model", 
                               "ARMA(1, 1) Model", "ARMA(2, 2) Model", 
                               "ARMA(2, 1) Model", "ARMA(1, 2) Model")

colnames(final_IC_result) <- c("AIC Score", "AICc Score", "BIC Score")

final_IC_result




# Addressing Potential Heteroskedasticity

apple_arima_resid <- sarima(apple_data_transformed, 1, 0, 0, details = FALSE)$fit$resid

acf2(apple_arima_resid^2, main = "Series: Squared Model Residuals")




# Enhancing Model Fit

library(fGarch)

apple_garch <- garchFit(~arma(1, 0) + garch(1, 1), data = apple_data_transformed, 
                        cond.dist = "std", trace = FALSE)

summary(apple_garch)




# Forecasting

final_forecast <- predict(apple_garch, n.ahead = 20, plot = TRUE)

final <- data.frame(cbind(final_forecast$meanForecast, final_forecast$lowerInterval, final_forecast$upperInterval))

colnames(final) <- c("Mean Forecast", "Lower Bound", "Upper Bound")

rownames(final) <- c("May 2025", "June 2025", "July 2025", "August 2025", "September 2025", "October 2025", "November 2025", "December 2025", "January 2026", "February 2026", "March 2026", "April 2026", "May 2026", "June 2026", "July 2026", "August 2026", "September 2026", "October 2026", "November 2026", "December 2026")

final


