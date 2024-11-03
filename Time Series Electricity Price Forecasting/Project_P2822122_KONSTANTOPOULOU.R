# Set working directory
setwd("~/Desktop/MSc Business Analytics/6th Semester/Advanced Topics in Statistics")

# Install required packages
install.packages("readxl")
install.packages("lubridate")

# Load necessary libraries
library("readxl")
library(lubridate)
library(viridis)
library(tseries)
library(forecast)
library(dplyr)
library(zoo)

# Read the xls file
data <- read_excel("electricity price data.xlsx", col_names = FALSE)
data
View(data)

# Rename the columns
names(data) <- c("Date1", "Price1", "Date2", "Price2", "Date3", "Price3", "Date4", "Price4", "Date5", "Price5",
                 "Date6", "Price6", "Date7", "Price7", "Date8", "Price8", "Date9", "Price9")

# Parse date columns into appropriate date format
date_columns <- c("Date1", "Date2", "Date3", "Date4", "Date5", "Date6", "Date7", "Date8", "Date9")
data[date_columns] <- lapply(data[date_columns], function(x) parse_date_time(x, orders = c("ymd", "mdy", "dmy")))

# Convert price columns to numeric format
price_columns <- c("Price1", "Price2", "Price3", "Price4", "Price5", "Price6", "Price7", "Price8", "Price9")
data[price_columns] <- lapply(data[price_columns], function(x) as.numeric(gsub(",", ".", gsub("\\s", "", x))))

#Retrieve the prices for each year
prices_2010 <- data[1:164, 'Price1']
names(prices_2010)[names(prices_2010) == 'Price1'] <- 'Price'

prices_2011 <- data[1:365, 'Price2']
names(prices_2011)[names(prices_2011) == 'Price2'] <- 'Price'

prices_2012 <- data[1:366, 'Price3']
prices_2012 <- prices_2012[-c(60), ]
names(prices_2012)[names(prices_2012) == 'Price3'] <- 'Price'

prices_2013 <- data[1:365, 'Price4']
names(prices_2013)[names(prices_2013) == 'Price4'] <- 'Price'

prices_2014 <- data[1:365, 'Price5']
names(prices_2014)[names(prices_2014) == 'Price5'] <- 'Price'

prices_2015 <- data[1:365, 'Price6']
names(prices_2015)[names(prices_2015) == 'Price6'] <- 'Price'

prices_2016 <- data[1:366, 'Price7']
prices_2016 <- prices_2016[-c(60), ]
names(prices_2016)[names(prices_2016) == 'Price7'] <- 'Price'

prices_2017 <- data[1:365, 'Price8']
names(prices_2017)[names(prices_2017) == 'Price8'] <- 'Price'

prices_2018 <- data[1:365, 'Price9']
names(prices_2018)[names(prices_2018) == 'Price9'] <- 'Price'

#Retrieve the dates
date_2010 <- data[1:164, 'Date1']
date_2010 <- as.Date(date_2010$Date1 , format = "%Y.%m.%d")
date_2010 <- as.data.frame(date_2010)
names(date_2010)[names(date_2010) == 'date_2010'] <- 'Date'

date_2011 <- data[1:365, 'Date2']
date_2011 <- as.Date(date_2011$Date2 , format = "%Y-%m-%d")
date_2011 <- as.data.frame(date_2011)
names(date_2011)[names(date_2011) == 'date_2011'] <- 'Date'

date_2012 <- data[1:366, 'Date3']
date_2012 <- date_2012[-c(60), ]
date_2012 <- as.Date(date_2012$Date3 , format = "%-%m-%d")
date_2012 <- as.data.frame(date_2012)
names(date_2012)[names(date_2012) == 'date_2012'] <- 'Date'

date_2013 <- data[1:365, 'Date4']
date_2013 <- as.Date(date_2013$Date4 , format = "%Y-%m-%d")
date_2013 <- as.data.frame(date_2013)
names(date_2013)[names(date_2013) == 'date_2013'] <- 'Date'

date_2014 <- data[1:365, 'Date5']
date_2014 <- as.Date(date_2014$Date5 , format = "%Y-%m-%d")
date_2014 <- as.data.frame(date_2014)
names(date_2014)[names(date_2014) == 'date_2014'] <- 'Date'

date_2015 <- data[1:365, 'Date6']
date_2015 <- as.Date(date_2015$Date6 , format = "%Y-%m-%d")
date_2015 <- as.data.frame(date_2015)
names(date_2015)[names(date_2015) == 'date_2015'] <- 'Date'

date_2016 <- data[1:366, 'Date7']
date_2016 <- date_2016[-c(60), ]
date_2016 <- as.Date(date_2016$Date7 , format = "%Y-%m-%d")
date_2016 <- as.data.frame(date_2016)
names(date_2016)[names(date_2016) == 'date_2016'] <- 'Date'

date_2017 <- data[1:365, 'Date8']
date_2017 <- as.Date(date_2017$Date8 , format = "%Y-%m-%d")
date_2017 <- as.data.frame(date_2017)
names(date_2017)[names(date_2017) == 'date_2017'] <- 'Date'

date_2018 <- data[1:365, 'Date9']
date_2018 <- as.Date(date_2018$Date9 , format = "%d.%m.%Y")
date_2018 <- as.data.frame(date_2018)
names(date_2018)[names(date_2018) == 'date_2018'] <- 'Date'

#Combine the dataframes above into one final df
Date <- rbind(date_2010, date_2011, date_2012,date_2013,date_2014,date_2015,date_2016,date_2017,date_2018)

Price <- rbind(prices_2010, prices_2011, prices_2012, prices_2013, prices_2014, prices_2015, prices_2016, prices_2017, prices_2018)

#Creating new dataframe with all dates and prices
data_new <- cbind(Date,Price)
View(data_new)
str(data_new)

#Checking for N/As
colSums(is.na(data_new)) 

#We have N/A value for Price
data_new <- data_new[complete.cases(data_new), ]
summary(data_new)

#We have some 2 prices below zero
subset(data_new, Price <= 0)
#We have one very high outlier with price 1147.9560 at 16/08/2010
data_new <- subset(data_new, Price <=600)

par(mfrow=c(1,1))
# Create a time series object and plot
j <- ts(data_new$Price, frequency = 365, start = c(2010, 202))
# Plot the time series
plot(j, type = "l", col = viridis(1), lty = "solid", ylab = "Price")
var(j)
j_filtered <- j[j > 0] #Since we had some values below zero that would result to N/A
lj=log(j_filtered)        # compute the logarithm 
dlj=diff(lj)   # compute the first differences of the log

par(mfrow=c(1,1))  # set up the graphics

####### Time Series plot #######
plot(j, type = "l", col = viridis(1), lwd = 1, main = "Time Series plot of daily price of the kilowatt hour", ylab = "Price (kWh)")
# Histogram
hist(j, nclass = 20, main = "Histogram of daily price of the kilowatt hour", col = viridis(15), xlab = "Price (kWh)", ylab = "Frequency")
# Perform the Augmented Dickey-Fuller test
adf_test <- adf.test(j)
adf_test
#Based on the Augmented Dickey-Fuller test results, with a p-value of 0.01, we can reject the null hypothesis of non-stationarity. The alternative hypothesis is that the time series is stationary.
#Therefore, with a significance level of 0.01, we have enough evidence to conclude that your time series data is stationary

# Focus on the price of the kilowatt hour
shapiro.test(j)          # normality test
par(mfrow=c(2,1))         
hist(j, prob=TRUE, col = viridis(15), main = "Histogram of price of the kilowatt hour")
lines(density(j), col = viridis(1), lwd = 2)     # smooth it - ?density for details 
qqnorm(j, col = viridis(1), main = "Normal QQplot of j")      # normal Q-Q plot  
qqline(j)

par(mfrow=c(1,2))  # set up the graphics  
acf(j, 30, main="ACF of price of the kilowatt hour")      # autocorrelation function plot 
pacf(j, 30, main="PACF of price of the kilowatt hour")    # partial autocorrelation function 
#We can see patterns that repeat every seven days, so I included 30 lags to see that the behavior 
#start at 7 and repeats at multiples of 7 (e.g., 14, 21) in the autocorrelation and partial autocorrelation plots. 
#This allowed me to capture the autocorrelation and partial autocorrelation at the weekly level.

#Spliting train and test
n <- length(data_new$Price)
n_train <- floor(0.8 * n)  # 80% of data for training
train_data <- head(data_new, n_train)
test_data <- tail(data_new, n - n_train)

data_week <- train_data %>%
  group_by(Week = floor_date(Date, "week")) %>%
  summarise(Price = mean(Price, na.rm = TRUE))

data_filtered <- data_week %>%
  filter(Week >= as.Date("2016-01-03"))

data_week_test <- test_data %>%
  group_by(Week = floor_date(Date, "week")) %>%
  summarise(Price = mean(Price, na.rm = TRUE))

data_filtered_test <- data_week_test %>%
  filter(Week >= as.Date("2016-01-03"))

# Create a time series object and plot
j2 <- ts(data_filtered$Price, frequency = 52, start = c(2016))
# Plot the time series
par(mfrow=c(1,1))
plot(j2, type = "l", col = "royalblue", lty = "solid",  ylab = "Price")
# Perform the Augmented Dickey-Fuller test
adf_test <- adf.test(j2)
adf_test 
var(j2)
lj2=log(j2)   # compute the logarithm 
# Perform the Augmented Dickey-Fuller test
adf_test <- adf.test(lj2)
adf_test 
dlj2=diff(lj2) # compute the first differences of the log
# Perform the Augmented Dickey-Fuller test
adf_test <- adf.test(dlj2)
adf_test

par(mfrow = c(1, 2))  # set up the graphics
plot(lj2, type = "l", col = viridis(1), lwd = 1, main = "Time Series plot of log of weekly price of the kilowatt hour", ylab = "Log Price", cex.main = 0.8)
plot(dlj2, type = "l", col = "cadetblue3", lwd = 1, main = "Time Series plot of differences of log of weekly price of the kilowatt hour", ylab = "Differences of Log Price", cex.main = 0.8)


par(mfrow=c(2,2))  # set up the graphics  
acf(j2, 52, main="ACF of price of the kilowatt hour")      # autocorrelation function plot 
pacf(j2, 52, main="PACF of price of the kilowatt hour")    # partial autocorrelation function 
acf(dlj2, 52, main="ACF of price of the kilowatt hour")      # autocorrelation function plot 
pacf(dlj2, 52, main="PACF of price of the kilowatt hour")    # partial autocorrelation function 


# Define the ranges for p, d, q, P, D, and Q
p_values <- c(0, 1, 2)    # Non-seasonal AR order
d <- 1                    # Non-seasonal differencing (usually set to 1)
q_values <- c(0, 1, 2)    # Non-seasonal MA order

P_values <- c(0, 1, 2)    # Seasonal AR order
D_values <- 1             # Seasonal differencing (usually set to 1)
Q_values <- c(0, 1, 2)    # Seasonal MA order

# Create a data frame to store the results
results <- data.frame(order_p = numeric(),
                      order_d = numeric(),
                      order_q = numeric(),
                      order_P = numeric(),
                      order_D = numeric(),
                      order_Q = numeric(),
                      AIC = numeric(),
                      stringsAsFactors = FALSE)

# Loop through the parameter combinations
for (p in p_values) {
  for (q in q_values) {
    for (P in P_values) {
      for (Q in Q_values) {
        # Fit ARIMA Models with specified orders
        order <- c(p, d, q)
        seasonal_order <- c(P, D_values, Q)
        model <- tryCatch(
          arima(lj2, order = order, seasonal = list(order = seasonal_order, period = 52)),
          error = function(e) NULL
        )
        
        # Check if the model was successfully fitted
        if (!is.null(model)) {
          # Store results in the data frame
          results <- bind_rows(results, data.frame(order_p = p,
                                                   order_d = d,
                                                   order_q = q,
                                                   order_P = P,
                                                   order_D = D_values,
                                                   order_Q = Q,
                                                   AIC = AIC(model)))
        }
      }
    }
  }
}

# Find the model with the minimum AIC

best_model <- results[which.min(results$AIC), ]

model <- arima(lj2, order = c(0, 1, 0), seasonal = list(order = c(0, 1, 0), period = 52))
model
AIC(model)
#-1.0959

# Diagnostic plots
modelresiduals=model$residuals
modelresiduals
residuals=ts(modelresiduals, frequency = 52, start = c(2016))
residuals
par(mfrow=c(3,2))        # set up the graphics  
acf(ts(residuals,freq=1), 48, main="ACF of residuals")        
pacf(ts(residuals,freq=1), 48, main="PACF of residuals") 
acf(ts(residuals^2,freq=1), 48, main="ACF of squared residuals")        
pacf(ts(residuals^2,freq=1), 48, main="PACF of squared residuals") 
qqnorm(residuals,main="Normal QQplot of residuals")  
qqline(residuals) 

############2017 forecast###############

# Forecasts
forecast=predict(model,method="rwdrift",89)   
forecast 

UL=forecast$pred+forecast$se
LL=forecast$pred-forecast$se

# Create a time series object for test dataset
j2_test <- ts(data_filtered_test$Price, frequency = 52, start = c(2017,18))
lj2_test <- log(j2_test)

# plot of forecasts with 1 s.e.
par(mfrow=c(1,1)) 
minx <- min(lj2, LL, lj2_test)
maxx <- max(lj2, UL, lj2_test)

# Generate viridis colors
colors_viridis <- viridis(3)

ts.plot(lj2, forecast$pred, xlim=c(2016,2018), ylim=c(minx, maxx), col = colors_viridis[1])
lines(forecast$pred, col = "blue", type = "l")
lines(UL, col = "orange", lty = "dashed")
lines(LL, col = "orange", lty = "dashed")
lines(lj2_test, col = colors_viridis[2], type = "l")
legend("topleft", legend = c("Forecast", "Upper Limit & Lower Limit", "Real Data"),
       col = c(colors_viridis[1], "orange", colors_viridis[2]),
       lty = c(1, 2, 1), lwd = 2, cex=0.8)

# Convert the forecasted data to a time series object with weekly frequency
forecast_ts <- ts(forecast$pred, frequency = 52, c(2017, 18))

accuracy(forecast$pred,data_filtered_test$Price)
summary(data_filtered_test$Price)

############2019 forecast###############

data_week <- data_new %>%
  group_by(Week = floor_date(Date, "week")) %>%
  summarise(Price = mean(Price, na.rm = TRUE))

data_filtered <- data_week %>%
  filter(Week >= as.Date("2016-01-03"))

j2 <- ts(data_filtered$Price, frequency = 52, start = c(2016))
lj2=log(j2) 
model <- arima(lj2, order = c(0, 1, 0), seasonal = list(order = c(0, 1, 0), period = 52))
View(data_filtered)

# Forecasts
forecast=predict(model,method="rwdrift",26)   
forecast 

UL=forecast$pred+forecast$se
LL=forecast$pred-forecast$se

# plot of forecasts with 1 s.e.
par(mfrow=c(1,1)) 
minx <- min(lj2, LL)
maxx <- max(lj2, UL)

ts.plot(lj2, forecast$pred, xlim=c(2016,2019.5), ylim=c(minx, maxx), col = colors_viridis[1])
lines(forecast$pred, col = "blue", type = "l")
lines(UL, col = "orange", lty = "dashed")
lines(LL, col = "orange", lty = "dashed")
legend("topleft", legend = c("Forecast", "Upper Limit & Lower Limit"),
       col = c("blue", "orange"),
       lty = c(1, 2), lwd = 2, cex=0.8)

# Calculate the average by 4 weeks (1 month)
average_by_month <- as.data.frame(rollapply(forecast$pred, width = 4, FUN = mean, by = 4, align = "right", fill = NA))

average_by_month <- average_by_month[is.na(average_by_month$x) == F,]
average_by_month

prices_first_half_2019 <- round(exp(average_by_month),2)
prices_first_half_2019
# 74.05  85.71  74.03  63.98  75.66 101.95
