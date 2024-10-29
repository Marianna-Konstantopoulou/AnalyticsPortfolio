setwd("~/Desktop/MSc Business Analytics/Big Data Systems and Architectures/Redis/RECORDED_ACTIONS")
# Load the library
library("redux")
library("dplyr")

# Create a connection to the local instance of REDIS
r <- redux::hiredis(
  redux::redis_config(
    host = "127.0.0.1", 
    port = "6379"))

##1##
#Read the csv file
modified_listings <- read.csv("modified_listings.csv")
View(modified_listings)
#Create a BITMAP called “ModificationsJanuary” using “SETBIT -> 1” for each user that modified their listing
for (i in 1:length(modified_listings$UserID)){
  if (modified_listings$ModifiedListing[i] ==1 & modified_listings$MonthID[i] ==1){
  r$SETBIT("ModificationsJanuary", modified_listings$UserID[i], "1")
  }
}
#Calculate the answer
r$BITCOUNT("ModificationsJanuary")

##2##
#Total users
length(unique(modified_listings$UserID))
#Performing inversion on the "ModificationsJanuary" BITMAP
r$BITOP("NOT","results","ModificationsJanuary")
#Using BITCOUNT to calculate the result
r$BITCOUNT("results")
#The total is 20000 which is different from 19999 users (as it should be).
#Since BITOP happens at byte-level increments, the results of the BITOP are always an integer number multiple of 8. 
#(as each byte has 8 bits)

##3##
#Read the csv file
emails_sent <- read.csv("emails_sent.csv")
View(emails_sent)
length(unique(emails_sent$UserID))
#JANUARY
for (i in 1:length(emails_sent$UserID)){
  if (emails_sent$MonthID[i] ==1){
    r$SETBIT("EmailsJanuary", as.character(emails_sent$UserID[i]), "1")
  }
}
#Calculate the answer
r$BITCOUNT("EmailsJanuary")

#FEBRUARY
for (i in 1:length(emails_sent$UserID)){
  if (emails_sent$MonthID[i] ==2){
    r$SETBIT("EmailsFebruary", as.character(emails_sent$UserID[i]), "1")
  }
}
#Calculate the answer
r$BITCOUNT("EmailsFebruary")

#MARCH
for (i in 1:length(emails_sent$UserID)){
  if (emails_sent$MonthID[i] ==3){
    r$SETBIT("EmailsMarch", as.character(emails_sent$UserID[i]), "1")
  }
}
#Calculate the answer
r$BITCOUNT("EmailsMarch")

r$BITOP("AND","results3",c("EmailsJanuary", "EmailsFebruary", "EmailsMarch"))
#Using BITCOUNT to calculate the result
r$BITCOUNT("results3")

##4##
#Creating a BITOP wth the users that received an email on January and March
r$BITOP("AND","results4",c("EmailsJanuary", "EmailsMarch"))
#Creating a BITOP with the users that didn't receive an email on February
r$BITOP("NOT","results5","EmailsFebruary")
#Combing the results
r$BITOP("AND", "results6", c("results5","results4"))
#Counting the results
r$BITCOUNT("results6")

##5##
emails_opened_jan <- subset(emails_sent, emails_sent$MonthID==1 & emails_sent$EmailOpened==1)

for (i in unique(emails_opened_jan$UserID)){
    r$SETBIT("EmailsOpenedJanuary", i, "1")
}
r$BITCOUNT("EmailsOpenedJanuary")

r$BITOP("NOT","EmailsNotOpened","EmailsOpenedJanuary")
r$BITCOUNT("EmailsNotOpened")

r$BITOP("AND", "EmailsNotOpenedJanuary", c("EmailsNotOpened","EmailsJanuary"))
r$BITCOUNT("EmailsNotOpenedJanuary")

r$BITOP("AND", "finalresult", c("EmailsNotOpenedJanuary","ModificationsJanuary"))
r$BITCOUNT("finalresult")

##6##

#FEBRUARY#
for (i in 1:length(modified_listings$UserID)){
  if (modified_listings$ModifiedListing[i] ==1 & modified_listings$MonthID[i] ==2){
    r$SETBIT("ModificationsFebruary", modified_listings$UserID[i], "1")
  }
}
#Calculate the answer
r$BITCOUNT("ModificationsFebruary")

emails_opened_feb <- subset(emails_sent, emails_sent$MonthID==2 & emails_sent$EmailOpened==1)

for (i in unique(emails_opened_feb$UserID)){
  r$SETBIT("EmailsOpenedFebruary", i, "1")
}
r$BITCOUNT("EmailsOpenedFebruary")

r$BITOP("NOT","EmailsNotOpened2","EmailsOpenedFebruary")
r$BITCOUNT("EmailsNotOpened2")

r$BITOP("AND", "EmailsNotOpenedFebruary", c("EmailsNotOpened2","EmailsFebruary"))
r$BITCOUNT("EmailsNotOpenedFebruary")

r$BITOP("AND", "finalresult2", c("EmailsNotOpenedFebruary","ModificationsFebruary"))
r$BITCOUNT("finalresult2")

#MARCH#
for (i in 1:length(modified_listings$UserID)){
  if (modified_listings$ModifiedListing[i] ==1 & modified_listings$MonthID[i] ==3){
    r$SETBIT("ModificationsMarch", modified_listings$UserID[i], "1")
  }
}
#Calculate the answer
r$BITCOUNT("ModificationsMarch")

emails_opened_mar <- subset(emails_sent, emails_sent$MonthID==3 & emails_sent$EmailOpened==1)

for (i in unique(emails_opened_mar$UserID)){
  r$SETBIT("EmailsOpenedMarch", i, "1")
}
r$BITCOUNT("EmailsOpenedMarch")

r$BITOP("NOT","EmailsNotOpened3","EmailsOpenedMarch")
r$BITCOUNT("EmailsNotOpened3")

r$BITOP("AND", "EmailsNotOpenedMarch", c("EmailsNotOpened3","EmailsMarch"))
r$BITCOUNT("EmailsNotOpenedMarch")

r$BITOP("AND", "finalresult3", c("EmailsNotOpenedMarch","ModificationsMarch"))
r$BITCOUNT("finalresult3")

r$BITOP("OR", "finalresult4", c("finalresult", "finalresult2", "finalresult3"))
r$BITCOUNT("finalresult4")

##7##

r$BITOP("AND", "Jan_opened_modified", c("EmailsOpenedJanuary","ModificationsJanuary"))
r$BITCOUNT("Jan_opened_modified")
r$BITCOUNT("ModificationsJanuary")
#=2797/9969= 28% of the modifications came from opened emails in January

r$BITOP("AND", "Feb_opened_modified", c("EmailsOpenedFebruary","ModificationsFebruary"))
r$BITCOUNT("Feb_opened_modified")
r$BITCOUNT("ModificationsFebruary")
#=2874/10007= 28.7%  of the modifications came from opened emails in February

r$BITOP("AND", "Mar_opened_modified", c("EmailsOpenedMarch","ModificationsMarch"))
r$BITCOUNT("Mar_opened_modified")
r$BITCOUNT("ModificationsMarch")
#=2783/9991= 27.8%  of the modifications came from opened emails in March

#On average only 28.13% of the Modified Listings came from people that opened the emails
#so we can assume that this strategy is not working well.

