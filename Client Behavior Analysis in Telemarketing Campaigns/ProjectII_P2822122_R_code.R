# Loading
setwd("~/Desktop/MSc Business Analytics/Statistics for BA II/Project I")
install.packages("readxl")
install.packages("ROCR")
install.packages("randomForest")
library("readxl")
library(aod)
library(psych)
library(glmnet)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ROCR)
library('class')
library('e1071')
library(randomForest)
library(hrbrthemes)
require(gridExtra)
###################################################################
###   CLASSIFICATION
###################################################################
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

#Data Split
#We split the data set in 3 parts to train, test and validation
set.seed(42)
my_data$id <- 1:nrow(my_data)
validation <- my_data %>% sample_frac(.15)
my_data2 <- anti_join(my_data, validation, by = 'id')
train <- my_data2 %>% sample_frac(.70)
test  <- anti_join(my_data2, train, by = 'id')
validation$id <- NULL
train$id <- NULL
test$id <- NULL
dim(train)
dim(test)
dim(validation)

###################################################################
###   Logistic Regression
###################################################################

#Fit full model
mylogit <- glm(SUBSCRIBED ~., family = binomial(link = "logit"), data = train)
summary(mylogit)

# Fit lasso glm
lambdas <- 10 ^ seq(8,-4,length=250)
x_matrix <- model.matrix(mylogit)[,-1]
fit_lasso <- glmnet(x_matrix, train$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial")

plot(fit_lasso, label = TRUE)
plot(fit_lasso, xvar = "lambda", label = TRUE)

# Cross Validation 
lasso.cv <- cv.glmnet(x_matrix,train$SUBSCRIBED, alpha=1, lambda=lambdas, family="binomial", type.measure='class')
plot(lasso.cv)
coef(lasso.cv, s = lasso.cv$lambda.1se)	# the most regularized model such that error is within one standard error of the minimum
lasso_model <- glm(SUBSCRIBED ~.-age-loan-previous-euribor3m, family = binomial(link = "logit"), data = train)

#Stepwise method with AIC and direction "both"
step(lasso_model, trace=TRUE, direction = "both")
modelstep <- glm(formula = SUBSCRIBED ~ job + marital + default + contact + 
                   month + duration + campaign + poutcome + emp.var.rate + cons.price.idx + 
                   nr.employed, family = binomial(link = "logit"), data = train)
summary(modelstep)

#Checking for multi-collinearity, GVIFs are calculated and compared with 3.16
require(car)
round(vif(modelstep),1)
model <- glm(formula = SUBSCRIBED ~ job + marital + default + contact + 
               month + duration + campaign + poutcome + cons.price.idx + 
               nr.employed, family = binomial(link = "logit"), data = train)
round(vif(model),1)
summary(model)

#ROC CURVE
#we will use test data to do the fine-tuning for finding the best p
predicted_prob <- predict(model, test, type = "response")
prediction <- as.integer(predicted_prob > 0.5)
test$SUBSCRIBED <- ifelse(test$SUBSCRIBED == 'yes', 1, 0)
confusion_mat_arx <- addmargins(table(test$SUBSCRIBED, prediction))
#Precision
precision_arxiko <- (confusion_mat_arx[2,2]/(confusion_mat_arx[2,2]+confusion_mat_arx[1,2]))
#Recall
recall_arxiko  <-  (confusion_mat_arx[2,2]/(confusion_mat_arx[2,2]+confusion_mat_arx[2,1]))
#F1 Score
f1_score_arxiko <- (2*((precision_arxiko*recall_arxiko)/(precision_arxiko+recall_arxiko)))
#0.44

library(ROCR)
prediction(predicted_prob, test$SUBSCRIBED) %>%
  performance(measure = "tpr", x.measure = "fpr") -> result

plotdata <- data.frame(x = result@x.values[[1]],
                       y = result@y.values[[1]], 
                       p = result@alpha.values[[1]])

p <- ggplot(data = plotdata) +
  geom_path(aes(x = x, y = y)) + 
  xlab(result@x.name) +
  ylab(result@y.name) +
  theme_bw()

dist_vec <- plotdata$x^2 + (1 - plotdata$y)^2
opt_pos <- which.min(dist_vec)

p + 
  geom_point(data = plotdata[opt_pos, ], 
             aes(x = x, y = y), col = "red") +
  annotate("text", 
           x = plotdata[opt_pos, ]$x + 0.1,
           y = plotdata[opt_pos, ]$y,
           label = paste("p =", round(plotdata[opt_pos, ]$p, 3)))

#We will now use the new threshold p=0.087
set.seed(42)
my_data$id <- 1:nrow(my_data)
validation <- my_data %>% sample_frac(.15)
my_data2 <- anti_join(my_data, validation, by = 'id')
train <- my_data2 %>% sample_frac(.70)
test  <- anti_join(my_data2, train, by = 'id')
validation$id <- NULL
train$id <- NULL
test$id <- NULL
predicted_prob_new <- predict(model, test, type = "response")
prediction_new <- as.integer(predicted_prob_new > 0.087)
test$SUBSCRIBED <- ifelse(test$SUBSCRIBED == 'yes', 1, 0)
confusion_mat <- addmargins(table(test$SUBSCRIBED, prediction_new))
#Precision
precision_teliko <- (confusion_mat[2,2]/(confusion_mat[2,2]+confusion_mat[1,2]))
#Recall
recall_teliko  <-  (confusion_mat[2,2]/(confusion_mat[2,2]+confusion_mat[2,1]))
#F1 Score
f1_score_teliko <- (2*((precision_teliko*recall_teliko)/(precision_teliko+recall_teliko)))
#0.53

###################################################################
###   Naive Bayes
###################################################################
model_naive <- naiveBayes(SUBSCRIBED ~ ., data = train) 
model_naive
p2 <- predict(model_naive, test)
(tab2 <- table(p2, test$SUBSCRIBED))
#Precision
precision_naive <- (tab2[2,2]/(tab2[2,2]+tab2[1,2]))
#Recall
recall_naive  <-  (tab2[2,2]/(tab2[2,2]+tab2[2,1]))
#F1 Score
f1_score_naive <- (2*((precision_naive*recall_naive)/(precision_naive+recall_naive)))
#0.45


###################################################################
###   Random Forest
###################################################################
rf <- randomForest(SUBSCRIBED~., data=train, ntree=200, importance=TRUE)
#Prediction & Confusion Matrix – test data
p4 <- predict(rf, test, type='class')
tab4 <- table(p4, test$SUBSCRIBED)
#Precision
precision_rf_test <- (tab4[2,2]/(tab4[2,2]+tab4[1,2]))
#Recall
recall_rf_test <-  (tab4[2,2]/(tab4[2,2]+tab4[2,1]))
#F1 Score
f1_score_rf_test <- (2*((precision_rf_test*recall_rf_test)/(precision_rf_test+recall_rf_test)))
#0.54

f1_warehouse <- matrix(data=NA, ncol=1, nrow=19)
for (i in 2:20){
  rf <- randomForest(SUBSCRIBED~., data=train, ntree=200, importance=TRUE, mtry=i)
  #Prediction & Confusion Matrix – test data
  p4 <- predict(rf, test, type='class')
  tab4 <- table(p4, test$SUBSCRIBED)
  #Precision
  precision_rf_test <- (tab4[2,2]/(tab4[2,2]+tab4[1,2]))
  #Recall
  recall_rf_test <-  (tab4[2,2]/(tab4[2,2]+tab4[2,1]))
  #F1 Score
  f1_score_rf_test <- (2*((precision_rf_test*recall_rf_test)/(precision_rf_test+recall_rf_test)))
  f1_warehouse[i-1,] <-  f1_score_rf_test
}

rf_final <- randomForest(SUBSCRIBED~., data=train, ntree=200, importance=TRUE, mtry=17)
#Prediction & Confusion Matrix – test data
p4_final <- predict(rf_final, test, type='class')
tab4_final <- table(p4_final, test$SUBSCRIBED)
#Precision
precision_rf_test_final <- (tab4_final[2,2]/(tab4_final[2,2]+tab4_final[1,2]))
#Recall
recall_rf_test_final <-  (tab4_final[2,2]/(tab4_final[2,2]+tab4_final[2,1]))
#F1 Score
f1_score_rf_test_final <- (2*((precision_rf_test_final*recall_rf_test_final)/(precision_rf_test_final+recall_rf_test_final)))
f1_score_rf_test_final
#0.5445

#Choosing our best method Random Forest
rf_validation <- randomForest(SUBSCRIBED~., data=train, ntree=200, importance=TRUE, mtry=17)
#Prediction & Confusion Matrix – validation data
p4_validation <- predict(rf_validation, validation, type='class')
tab4_validation <- table(p4_validation, validation$SUBSCRIBED)
#Precision
precision_rf_validation <- (tab4_validation[2,2]/(tab4_validation[2,2]+tab4_validation[1,2]))
#Recall
recall_rf_validation <-  (tab4_validation[2,2]/(tab4_validation[2,2]+tab4_validation[2,1]))
#F1 Score
f1_score_rf_validation <- (2*((precision_rf_validation*recall_rf_validation)/(precision_rf_validation+recall_rf_validation)))
f1_score_rf_validation
#0.5577
#Accuracy
accuracy <- sum(tab4_validation[1,1],tab4_validation[2,2])/sum(tab4_validation)
#91.6% 



###################################################################
###   CLUSTERING
###################################################################
library("readxl")
library(cluster)
library(dplyr)
library(ggplot2)
library(readr)
library(Rtsne)
library(mclust)
# xls files
clust_data <- read_excel("project I  2021-2022.xls")
clust_data$contact <- NULL
clust_data$month <- NULL
clust_data$day_of_week <- NULL
clust_data$duration <- NULL
clust_data$emp.var.rate <- NULL
clust_data$cons.conf.idx <- NULL
clust_data$cons.price.idx <- NULL
clust_data$euribor3m <- NULL
clust_data$nr.employed <- NULL
actual <- as.data.frame(as.factor(clust_data$SUBSCRIBED))
clust_data$SUBSCRIBED <- NULL
clust_data$job <- as.factor(clust_data$job)
clust_data$marital <- as.factor(clust_data$marital)
clust_data$education <- as.factor(clust_data$education)
clust_data$default <- as.factor(clust_data$default)
clust_data$housing <- as.factor(clust_data$housing)
clust_data$loan <- as.factor(clust_data$loan)
clust_data$poutcome <- as.factor(clust_data$poutcome)
clust_data$pdays <- NULL
str(clust_data)

#Take a random sample of 10.000 observations
set.seed(1997)
index <- sample(1:nrow(clust_data), size = 10000, replace = FALSE)
clust_data_sample <- clust_data[index,]
head(clust_data_sample)
actual_sample <- actual[index,]

#Create distance matrix using Gower Distance
distance <- daisy(clust_data_sample, metric = "gower")

#Hierarchical clustering with Ward linkage
clusters <- hclust(distance, method = "ward.D")

#Cluster dendrogram
par(mfrow=c(1,1))
plot(clusters, cex = 0.1, hang = -1)
rect.hclust(clusters, k=2, border="red")

#Height plot
plot(clusters$height)

#Silhouette value
par(mfrow=c(1,1))
plot(silhouette(cutree(clusters, k = 2), dist = distance),col = c("#69b3a2", "#FFDB6D"), border=NA)

#Comparing with the actual values
adjustedRandIndex((cutree(clusters, k=2)),actual_sample) 
#We obtained a negative adjusted rand index, indicating that the agreement is lower than what would be anticipated from a random outcome.

#Summary of observations in each cluster
cluster1 <- clust_data_sample[which(cutree(clusters, k = 2)==1),]
cluster2 <- clust_data_sample[which(cutree(clusters, k = 2)==2),]
summary(cluster1)
summary(cluster2)

#age
hist_cluster1_age <- cluster1 %>%
  ggplot( aes(x=age)) +
  geom_histogram( binwidth=10, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  ggtitle("Cluster 1 Age") +
  scale_x_continuous(breaks=seq(from = 0, to = 100, by = 10)) +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )
hist_cluster1_age
hist_cluster2_age <- cluster2 %>%
  ggplot( aes(x=age)) +
  geom_histogram( binwidth=10, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  ggtitle("Cluster 2 Age") +
  scale_x_continuous(breaks=seq(from = 0, to = 100, by = 10)) +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )
hist_cluster2_age 

grid.arrange(hist_cluster1_age, hist_cluster2_age, ncol=2)

#job
bar_cluster1_job <- ggplot(data = cluster1, aes(x = job)) +
  geom_bar(fill = "#00AFBB") + ggtitle("Cluster 1") +theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
bar_cluster2_job <- ggplot(data = cluster2, aes(x = job)) +
  geom_bar(fill = "#FFDB6D") + ggtitle("Cluster 2")+ theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
grid.arrange(bar_cluster1_job, bar_cluster2_job, ncol=2)

#marital
bar_cluster1_marital <- ggplot(data = cluster1, aes(x = marital)) +
  geom_bar(fill = "blue") + theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
bar_cluster2_marital <- ggplot(data = cluster2, aes(x = marital)) +
  geom_bar(fill = "orange") + theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
grid.arrange(bar_cluster1_marital, bar_cluster2_marital, ncol=2)

#education
bar_cluster1_education <- ggplot(data = cluster1, aes(x = education)) +
  geom_bar(fill = "#4E84C4") + ggtitle("Cluster 1") + theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
bar_cluster2_education <- ggplot(data = cluster2, aes(x = education)) +
  geom_bar(fill = "#52854C") + ggtitle("Cluster 2") + theme_bw() +
  theme(axis.text.x=element_text(size=rel(1), angle=90))
grid.arrange(bar_cluster1_education, bar_cluster2_education, ncol=2)

par(mfrow=c(1,2))
#default
plot(cluster1$default)
plot(cluster2$default)
#housing
plot(cluster1$housing)
plot(cluster2$housing)
#loan
plot(cluster1$loan)
plot(cluster2$loan)
#campaign
hist(cluster1$campaign)
hist(cluster2$campaign)
#previous
hist(cluster1$previous)
hist(cluster2$previous)
#poutcome
plot(cluster1$poutcome)
plot(cluster2$poutcome)

