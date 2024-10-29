###1### 
setwd("~/Desktop/MSc Business Analytics/Statistics for Business Analytics I/Final Assignment")
library(ggplot2)
library(dplyr)
library(relaimpo)
library(RColorBrewer)
Bikes <- read.csv("bike_40.csv", sep = ";")
View(Bikes)

#Cleaning the dataset
Bikes$instant <- NULL
Bikes$X <- NULL #since X is the same as instant
Bikes$dteday <- NULL
Bikes$casual <- NULL
Bikes$registered <- NULL
str(Bikes)
head(Bikes)
ncol(Bikes) #number of columns
nrow(Bikes) #number of rows

Bikes$season <- factor(Bikes$season, labels=c('Winter', 'Spring', 'Summer', 'Fall'))
Bikes$yr  <- factor(Bikes$yr, labels=c('2011', '2012'))
Bikes$mnth <- factor(Bikes$mnth, labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
Bikes$hr <- as.factor(Bikes$hr)
Bikes$holiday <- factor(Bikes$holiday, labels=c('No', 'Yes'))
Bikes$weekday <- factor(Bikes$weekday, labels=c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'))
Bikes$workingday <- factor(Bikes$workingday, labels=c('No', 'Yes'))
Bikes$weathersit <- factor(Bikes$weathersit, labels=c('Clear/Partly Cloudy','Mist/Cloudy','Light Snow/Light Rain','Heavy Rain/Thunderstorm/Snow'))
Bikes$temp <- as.numeric(gsub(",", ".", Bikes$temp))*41
Bikes$atemp <- as.numeric(gsub(",", ".", Bikes$atemp))*50
Bikes$hum <- as.numeric(gsub(",", ".", Bikes$hum))*100
Bikes$windspeed <- as.numeric(gsub(",", ".", Bikes$windspeed))*67
Bikes$cnt <- as.numeric(Bikes$cnt)
str(Bikes)
sum(is.na(Bikes)) #we are checking for missing values


#Split the numeric and factor variables so we can do visual analysis
library(psych)
index <- sapply(Bikes, class) == 'numeric'
Bikesnum <- Bikes[ ,index]
describenum <- round(t(describe(Bikesnum)),2)

#Histograms
par(mfrow=c(2,4))
y <- Bikesnum
p <- ncol(y)
for (i in 1:p){
  hist(y[,i], main=names(y)[i],col='royalblue', probability=TRUE) 
  index <- seq( min(y[,i]), max(y[,i]), length.out=100)
  ynorm <- dnorm( index, mean=mean(y[,i]), sd(y[,i]) )
}

#Visual Analysis for factors 
Bikesfac <- Bikes[,!index]
str(Bikesfac)
par(mfrow=c(2,4))
n <- nrow(Bikesfac)
for (i in 1:8){
  barplot(table(Bikesfac[,i])/n,main=names(Bikesfac)[i],border="blue", col="orange",ylab='Relative frequency')
}

summary(Bikesfac)
#Pairs of numerical variables
pairs(Bikesnum, pch = 16, col = "blue")

install.packages("gridExtra")
library(gridExtra)
grid.arrange(plot1, plot3, plot4,plot5, ncol=3, nrow = 2)
#Temperature
plot1 <- ggplot(Bikesnum,aes(cnt,temp)) +
  geom_point() +
  geom_smooth(method = "loess") +
  theme_classic()
#Feeling Temperature
plot3 <- ggplot(Bikesnum,aes(cnt,atemp)) +
  geom_point() +
  geom_smooth(method = "loess") +
  theme_classic()
#Humidity
plot4 <- ggplot(Bikesnum,aes(cnt,hum)) +
  geom_point() +
  geom_smooth(method = "loess") +
  theme_classic()
#Windspeed
plot5 <- ggplot(Bikesnum,aes(cnt,windspeed)) +
  geom_point() +
  geom_smooth(method = "loess") +
  theme_classic()

dev.off()


###Count (our response) on factor variables ###

grid.arrange(plot6, plot2, plot7, plot8, plot9,plot10, plot11, plot12, ncol=3, nrow = 3)

#Seasonal factors
col1 <- brewer.pal(4,"Set3")
plot6 <- ggplot(Bikes,aes(season,cnt)) +
  geom_boxplot(fill = col1) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per season") +
  scale_x_discrete(labels = c('Winter', 'Spring', 'Summer', 'Fall'))

#Hour factors
plot2 <- ggplot(Bikes,aes(hr,cnt)) +
  geom_boxplot(fill="#8DD3C7") +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per hours")

#Year factors
plot7 <- ggplot(Bikes,aes(yr,cnt)) +
  geom_boxplot(fill = c("#8DD3C7","#FFFFB3")) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per year") +
  scale_x_discrete(labels = c("2011","2012"))

#Month factors
col2 <- brewer.pal(12,"Set3")
plot8 <- ggplot(Bikes,aes(mnth,cnt)) +
  geom_boxplot(fill = col2) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per month") +
  scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

#Holiday factor
plot9 <- ggplot(Bikes,aes(holiday,cnt)) +
  geom_boxplot(fill = c("#8DD3C7","#FFFFB3")) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes by holiday") +
  scale_x_discrete(labels = c("no","yes"))

#Weekday factor
col3 <- brewer.pal(7,"Set3")
plot10 <- ggplot(Bikes,aes(weekday,cnt)) +
  geom_boxplot(fill = col3) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes by weekday") +
  scale_x_discrete(labels = c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'))

#Workingday factor
plot11 <- ggplot(Bikes,aes(workingday,cnt)) +
  geom_boxplot(fill = c("#8DD3C7","#FFFFB3")) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes by workingday") +
  scale_x_discrete(labels = c("no","yes"))

#Weather factor
col4 <- brewer.pal(4,"Set3")
plot12 <- ggplot(Bikes,aes(weathersit,cnt)) +
  geom_boxplot(fill = col4) +
  theme_classic() +
  labs(title = "Boxplot of rental bikes by weathersit") +
  scale_x_discrete(labels = c('Clear/Partly Cloudy','Mist/Cloudy','Light Snow/Light Rain','Heavy Rain/Thunderstorm/Snow'))

require(corrplot)
round(cor(Bikesnum), 2)
par(mfrow = c(1,1))
corrplot(cor(Bikesnum), method = "number")

###2###
#a)
require(glmnet)
model2 <- lm(cnt ~., data = Bikesnum)
model1 <- lm(cnt ~., data = Bikes)
summary(model1)
X <- model.matrix(model1)[,-1]
lasso <- glmnet(X, Bikes$cnt)
plot(lasso, xvar = "lambda", label = T)
#Use cross validation to find a reasonable value for lambda 
lasso1 <- cv.glmnet(X, Bikes$cnt, alpha = 1)
lasso1$lambda
lasso1$lambda.min #I prwti katheti grammi (is the one with the minimum CV-MSE)
lasso1$lambda.1se #I deuteri katheti grammi (largest value of lambda such that error is within 1 standard error of the minimum [more parsimonious ])
plot(lasso1)
coef(lasso1, s = "lambda.min")
coef(lasso1, s = "lambda.1se") 
plot(lasso1$glmnet.fit, xvar = "lambda")
abline(v=log(c(lasso1$lambda.min, lasso1$lambda.1se)), lty =2)
modellasso <- lm(cnt ~.-workingday, data = Bikes)
summary(modellasso)

modelstep <- step(modellasso, direction='both')
summary(modelstep)

step(model1, direction="both")

par(mfrow=c(2,2))
plot(modelstep)

###3###
#Checking multi-collinearity
#Using VIF 
require(car)
round(vif(modelstep),1)
#GVIFs are calculated and compared with 3.16 so we don't have a multi-collinearity issue

#Checking Normality
plot(modelstep, which = 2) #Normality of the residuals
#Our n>50 so we use KS+SW
shapiro.test(modelstep$residuals)
library(nortest)
lillie.test(modelstep$residuals)

#Checking constant variance
Stud.residuals <- rstudent(modelstep)
yhat <- fitted(modelstep)
par(mfrow=c(1,2))
#Fitted values vs. standardized or studentized residuals using
#95% quantiles from the correct distributions
plot(yhat, Stud.residuals)
abline(h=c(-2,2), col=2, lty=2)
#Fitted values vs. studentized residuals squared
plot(yhat, Stud.residuals^2)
abline(h=4, col=2, lty=2)
library(car)
ncvTest(modelstep)

#Non Linearity
library(car)
residualPlot(modelstep, type='rstudent')
residualPlots(modelstep, plot=F, type = "rstudent")
#Assumption of linearity not valid since some p-values are lower than 0.05
modelstep1 <- lm(log(cnt) ~ season + yr + mnth + hr + holiday + weekday + weathersit + atemp + hum + windspeed + poly(hum,2) +poly(atemp,2), data = Bikes)
residualPlot(modelstep1, type='rstudent')
residualPlots(modelstep1, plot=F, type = "rstudent")
summary(modelstep1)

modelstep2 <- lm(log(cnt) ~ season + yr + hr + atemp + hum + I(hum^2) + I(atemp^2) + I(atemp^3), data = Bikes)
residualPlot(modelstep2, type='rstudent')
residualPlots(modelstep2, plot=F, type = "rstudent")


#Independence
plot(rstudent(modelstep), type='l')
library(randtests); runs.test(modelstep$res)
library(lmtest);dwtest(modelstep1)
library(car); durbinWatsonTest(modelstep1)
#Indepedence is OK

#Transformations
modelstep1<-lm(formula = log(cnt) ~ season + yr + mnth + hr + holiday + weekday + weathersit + atemp + hum + windspeed +poly(hum,3) +poly(atemp,3), data = Bikes)
residualPlot(modelstep1, type='rstudent')
residualPlots(modelstep1, plot=F, type = "rstudent")
summary(modelstep1)

modelstep2<-lm(formula = log(cnt) ~ season + yr + mnth + hr + holiday + weekday + weathersit + atemp + hum + windspeed +I(hum^2) +I(atemp^2)+I(atemp^3), data = Bikes)
residualPlot(modelstep2, type='rstudent')
residualPlots(modelstep2, plot=F, type = "rstudent")
ncvTest(modelstep2)
#Homoscedasticity of the residuals (modelstep2)
wt <- 1 / lm(abs(modelstep2$residuals) ~ modelstep2$fitted.values)$fitted.values^2
#perform weighted least squares regression
weighted_model <- lm(log(cnt) ~ season + yr + mnth + hr + holiday + weekday + weathersit + atemp + hum + windspeed +I(hum^2) +I(atemp^2)+I(atemp^3) , data=Bikes, weight=wt)
summary(weighted_model)
library(car)
ncvTest(weighted_model)

#FINAL MODEL
weighted_model2 <- lm(log(cnt) ~ season + yr + mnth + hr + holiday + weekday + weathersit + atemp + hum + windspeed +I(hum^2)+ I(hum^3) +I(atemp^2)+I(atemp^3) , data=Bikes, weight=wt)
summary(weighted_model2)

#Checking Linearity 
residualPlots(weighted_model2, plot=F, type = "rstudent")
par(mfrow=c(2,2))
plot(weighted_model2)

#Checking homoscedasticity
ncvTest(weighted_model2)

#Checking the independence of the final model
library(randtests); runs.test(weighted_model2$res)
library(lmtest);dwtest(weighted_model2)
library(car); durbinWatsonTest(weighted_model2)

#Checking Normality
plot(weighted_model2, which = 2) #Normality of the residuals
#Our n>50 so we use KS+SW
shapiro.test(weighted_model2$residuals)
library(nortest)
lillie.test(weighted_model2$residuals)

par(mfrow=c(2,2))
plot(weighted_model2)

###4###
library(caret)
#Final Model Predictions
predicted <- predict(weighted_model2, Bikes, type='response')
actual <- Bikes[,'cnt']
sqrt(mean((exp(predicted)-actual)^2))
#Our  model is off by approximately 85 total bikes rentals

#Full Model Predictions
predicted_full <- predict(model1, Bikes, type='response')
actual_full <- Bikes[,'cnt']
sqrt(mean((predicted_full-actual_full)^2))
#Our  fullmodel is off by approximately 97 total bikes rentals

#Null model
modelnull <- lm(cnt~.-season-yr-mnth-hr-holiday-weekday-workingday-weathersit-temp-atemp-hum-windspeed,data = Bikes)
#Null Model Predictions
predicted_null <- predict(modelnull, Bikes, type='response')
actual_null <- Bikes[,'cnt']
sqrt(mean((predicted_null-actual_null)^2))
#Our  fullmodel is off by approximately 171 total bikes rentals

###5###
setwd("~/Desktop/MSc Business Analytics/Statistics for Business Analytics I/Final Assignment")
library(ggplot2)
library(dplyr)
library(relaimpo)
library(RColorBrewer)
Bikes_test <- read.csv("bike_test.csv", sep = ";")
View(Bikes_test)

#Cleaning the dataset
Bikes_test$instant <- NULL
Bikes_test$X <- NULL #since X is the same as instant
Bikes_test$dteday <- NULL
Bikes_test$casual <- NULL
Bikes_test$registered <- NULL
str(Bikes_tests)
head(Bikes_test)
ncol(Bikes_test) #number of columns
nrow(Bikes_test) #number of rows

Bikes_test$season <- factor(Bikes_test$season, labels=c('Winter', 'Spring', 'Summer', 'Fall'))
Bikes_test$yr  <- factor(Bikes_test$yr, labels=c('2011', '2012'))
Bikes_test$mnth <- factor(Bikes_test$mnth, labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
Bikes_test$hr <- as.factor(Bikes_test$hr)
Bikes_test$holiday <- factor(Bikes_test$holiday, labels=c('No', 'Yes'))
Bikes_test$weekday <- factor(Bikes_test$weekday, labels=c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'))
Bikes_test$workingday <- factor(Bikes_test$workingday, labels=c('No', 'Yes'))
Bikes_test$weathersit <- factor(Bikes_test$weathersit,levels=c(1,2,3,4), labels=c('Clear/Partly Cloudy','Mist/Cloudy','Light Snow/Light Rain','Heavy Rain/Thunderstorm/Snow'))
Bikes_test$temp <- as.numeric(gsub(",", ".", Bikes_test$temp))*41
Bikes_test$atemp <- as.numeric(gsub(",", ".", Bikes_test$atemp))*50
Bikes_test$hum <- as.numeric(gsub(",", ".", Bikes_test$hum))*100
Bikes_test$windspeed <- as.numeric(gsub(",", ".", Bikes_test$windspeed))*67
Bikes_test$cnt <- as.numeric(Bikes_test$cnt)
str(Bikes_test)
sum(is.na(Bikes_test)) #we are checking for missing values
summary(Bikes_test$weathersit)

#LASSO model
modellasso2 <- lm(cnt ~.-workingday, data = Bikes_test)
summary(modellasso2)

#Stepwise model
modelstep2 <- step(modellasso2, direction='both')
summary(modelstep2)

#Full model
model2 <- lm(cnt ~., data = Bikes_test)

#Null model
modelnull2 <- lm(cnt~.-season-yr-mnth-hr-holiday-weekday-workingday-weathersit-temp-atemp-hum-windspeed,data = Bikes_test)

#Full Model Predictions
predicted_full2 <- predict(model2, Bikes_test, type='response')
actual_full2 <- Bikes_test[,'cnt']
sqrt(mean((predicted_full2-actual_full2)^2))
#Our  fullmodel is off by approximately 96 total bikes rentals

#Null Model Predictions
predicted_null2 <- predict(modelnull2, Bikes_test, type='response')
actual_null2 <- Bikes_test[,'cnt']
sqrt(mean((predicted_null2-actual_null2)^2))
#Our  nullmodel is off by approximately 182 total bikes rentals

#LASSO model predictions
predicted_lasso2 <- predict(modellasso2, Bikes_test, type='response')
actual_lasso2 <- Bikes_test[,'cnt']
sqrt(mean((predicted_lasso2-actual_lasso2)^2))
#Our LASSO model is off by approximately 96 total bikes rentals

#Stepwise model predictions
predicted_step2 <- predict(modelstep2, Bikes_test, type='response')
actual_step2 <- Bikes_test[,'cnt']
sqrt(mean((predicted_step2-actual_step2)^2))
#Our stepwise model is off by approximately 98 total bikes rentals

###6###
Bikes6 <- read.csv("bike_40.csv",sep=';') 
str(Bikes6)
sum(is.na(Bikes6)) 

#Data Cleaning
Bikes6$X <- NULL
Bikes6$instant <- NULL
Bikes6$dteday <- NULL
Bikes6$season <- factor(Bikes6$season,labels=c('Winter','Spring','Summer','Fall')) 
Bikes6$yr <- factor(Bikes6$yr,labels=c(2011,2012))
Bikes6$hr <- as.factor(Bikes6$hr)
Bikes6$mnth <- factor (Bikes6$mnth, labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
Bikes6$holiday <- factor(Bikes6$holiday, labels=c('No','Yes'))
Bikes6$weekday <- factor(Bikes6$weekday,labels=c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'))
Bikes6$workingday <- factor(Bikes6$workingday,labels=c('No','Yes'))
Bikes6$weathersit <- factor(Bikes6$weathersit,levels=c(1,2,3,4),labels=c('Clear/Partly Cloudy','Mist/Cloudy','Light Snow/Light Rain','Heavy Rain/Thunderstorm/Snow'))
Bikes6$temp <- as.numeric(gsub(",", ".", Bikes6$temp))*41
Bikes6$atemp <- as.numeric(gsub(",", ".", Bikes6$atemp))*50
Bikes6$hum <- as.numeric(gsub(",", ".", Bikes6$hum))*100
Bikes6$windspeed <- as.numeric(gsub(",", ".", Bikes6$windspeed))*67
Bikes6$casual <- as.numeric(Bikes6$casual)
Bikes6$registered <- as.numeric(Bikes6$registered)
Bikes6$cnt <- as.numeric(Bikes6$cnt)

#Winter subset
Bikeswinter <- Bikes6[which(Bikes6$season=='Winter'),]
str(Bikeswinter)
describe(Bikeswinter)
index <- sapply(Bikeswinter, class) == "numeric"
Bikeswinternum <- Bikeswinter[index]
nrow(Bikeswinter)
par(mfrow=c(1,1))
barplot(table(Bikeswinter$weathersit)/nrow(Bikeswinter), main="Winter weather", ylab='Relative frequency', col='lightyellow')
ggplot(Bikeswinter,aes(hr,cnt)) +geom_boxplot(fill="#8DD3C7") +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per hours during Winter") +scale_x_discrete(labels = c("00:00", "01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"))

#Spring subset
Bikesspring <- Bikes6[which(Bikes6$season=='Spring'),]
str(Bikesspring)
describe(Bikesspring)
index <- sapply(Bikesspring, class) == "numeric"
Bikesspringnum <- Bikesspring[index]
nrow(Bikesspring)
par(mfrow=c(1,1))
barplot(table(Bikesspring$weathersit)/nrow(Bikesspring), main="Spring weather", ylab='Relative frequency', col='lightgreen')
ggplot(Bikesspring,aes(hr,cnt)) +geom_boxplot(fill="pink") +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per hours during Spring") +scale_x_discrete(labels = c("00:00", "01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"))

#Summer subset
Bikessummer <- Bikes6[which(Bikes6$season=='Summer'),]
str(Bikessummer)
describe(Bikessummer)
index <- sapply(Bikessummer, class) == "numeric"
Bikessummernum <- Bikessummer[index]
nrow(Bikessummer)
par(mfrow=c(1,1))
barplot(table(Bikessummer$weathersit)/nrow(Bikessummer), main="Summer weather", ylab='Relative frequency', col='lightblue')
ggplot(Bikesspring,aes(hr,cnt)) +geom_boxplot(fill="purple") +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per hours during Summer") +scale_x_discrete(labels = c("00:00", "01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"))

#Fall subset
BikesFall <- Bikes6[which(Bikes6$season=='Fall'),]
str(BikesFall)
describe(BikesFall)
index <- sapply(BikesFall, class) == "numeric"
BikesFallnum <- BikesFall[index]
nrow(BikesFall)
par(mfrow=c(1,1))
barplot(table(BikesFall$weathersit)/nrow(BikesFall), main="Fall weather", ylab='Relative frequency', col='orange')
ggplot(BikesFall,aes(hr,cnt)) +geom_boxplot(fill="yellowgreen") +
  theme_classic() +
  labs(title = "Boxplot of rental bikes per hours during Fall") +scale_x_discrete(labels = c("00:00", "01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"))

