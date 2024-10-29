--------------------------------------------
#Project I
--------------------------------------------
# Loading
setwd("~/Desktop/MSc Business Analytics/Statistics for BA II/Project I")
install.packages("readxl")
library("readxl")
library(aod)
library(psych)
library(glmnet)
library(tidyverse)
# xls files
my_data <- read_excel("project I  2021-2022.xls")

#Finding the correct types
str(my_data)
my_data$job <- as.factor(my_data$job)
my_data$marital <- as.factor(my_data$marital)
my_data$education <- as.factor(my_data$education)
my_data$default <- as.factor(my_data$default)
my_data$housing <- as.factor(my_data$housing)
my_data$loan <- as.factor(my_data$loan)
my_data$contact <- as.factor(my_data$contact)
my_data$month <- as.factor(my_data$month)
my_data$day_of_week <- as.factor(my_data$day_of_week)
my_data$poutcome <- as.factor(my_data$poutcome)
my_data$SUBSCRIBED<- as.factor(my_data$SUBSCRIBED)
my_data$cons.conf.idx <- as.numeric(my_data$cons.conf.idx)

my_data$pdays <- NULL

sum(is.na(my_data)) #we are checking for missing values

#Split the numeric and factor variables so we can do visual analysis
index <- sapply(my_data, class) == 'numeric'
my_datanum <- my_data[ ,index]
describenum <- round(t(describe(my_datanum)),2)

#Visual Analysis for factors 
my_datafac <- my_data[,!index]
str(my_datafac)
par(mfrow=c(3,4))
n <- nrow(my_datafac)
for (i in 1:11){
  barplot(table(my_datafac[,i])/n,main=names(my_datafac)[i],border="blue", col="light blue",ylab='Relative frequency', cex.main=0.80, cex.axis=0.75)
}
summary(my_datafac)
#Checking the correlation of numeric variables
require(corrplot)
round(cor(my_datanum), 2)
par(mfrow = c(1,1))
corrplot(cor(my_datanum), method = "number")

nrow(my_data)

#Fit full model
mylogit <- glm(SUBSCRIBED ~., family = binomial(link = "logit"), data = my_data)
summary(mylogit)

# Fit lasso glm
lambdas <- 10 ^ seq(8,-4,length=250)
x_matrix <- model.matrix(mylogit)[,-1]
fit_lasso <- glmnet(x_matrix, my_data$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial")

plot(fit_lasso, label = TRUE)
plot(fit_lasso, xvar = "lambda", label = TRUE)

# Cross Validation 
lasso.cv <- cv.glmnet(x_matrix,my_data$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial", type.measure='class')
plot(lasso.cv)
coef(lasso.cv, s = lasso.cv$lambda.min)	# min is somewhat sensitive to specific run
coef(lasso.cv, s = lasso.cv$lambda.1se)	# the most regularized model such that error is within one standard error of the minimum
lasso_model <- glm(SUBSCRIBED ~.-age-previous-cons.conf.idx-euribor3m, family = binomial(link = "logit"), data = my_data)

#Stepwise method with BIC and direction "both"
step(lasso_model, trace=TRUE, direction = "both", k = log(39883))
modelstep <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                   campaign + poutcome + emp.var.rate + cons.price.idx + nr.employed, 
                 family = binomial(link = "logit"), data = my_data)
summary(modelstep)

#Checking for multi-collinearity, GVIFs are calculated and compared with 3.16
require(car)
round(vif(modelstep),1)
model <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                      campaign + poutcome + cons.price.idx + nr.employed, 
                    family = binomial(link = "logit"), data = my_data)
summary(model)
round(vif(model),1)
plot(model)

confint(model)
round(confint.default(model),2)
wald.test(b = coef(model), Sigma = vcov(model), Terms = c(2:19))
wald.test(b = coef(model), Sigma = vcov(model), Terms = 18)

coef(model)[18]
finalmodel <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                    campaign + poutcome + nr.employed, 
                  family = binomial(link = "logit"), data = my_data)

#Deviance check
with(finalmodel, pchisq(deviance, df.residual,lower.tail = FALSE)) #Goodness of fit

str(my_data)
summary(finalmodel)
#Deviance residuals
residuals(finalmodel,type = "deviance")
par(mfrow = c(2,4), mar = c(5,5,1,1))
plot(as.numeric(my_data$default), resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'default', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 1.5)
plot(as.numeric(my_data$contact) , resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'contact', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 1.5)
plot(as.numeric(my_data$month) , resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'month', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 1.5)
plot(my_data$duration, resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'duration', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'blue', cex = 1.5)
plot(my_data$campaign , resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'campaign', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'blue', cex = 1.5)
plot(as.numeric(my_data$poutcome) , resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'poutcome', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'red', cex = 1.5)
plot(my_data$nr.employed, resid(finalmodel, type = 'deviance'), ylab = 'Residuals (Deviance)', xlab = 'nr.employed', cex.lab = 1.5, cex.axis = 1.5, pch = 16, col = 'blue', cex = 1.5)
dev.off()

round(coef(finalmodel),3)

#Model comparisons
with(finalmodel, pchisq(null.deviance - deviance,df.null - df.residual, lower.tail = FALSE))
#There is significant difference between our model and the null model.

anova(model,finalmodel,test='LRT')
#There is no statistical difference between our final model and the model including the cons.price.idx

#Model with centered covariates
my_datacentered <- as.data.frame(scale(my_datanum, center = TRUE, scale= F )) 
my_datacentered <- cbind(my_datacentered, my_datafac)

finalmodel2 <- glm(formula = SUBSCRIBED ~ default + contact + month + duration + 
                       campaign + poutcome + nr.employed, 
                     family = binomial(link = "logit"), data = my_datacentered)

summary(finalmodel2) #we need this in order to interpret b0
