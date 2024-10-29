# LIBRARIES #

library(jsonlite)
library(mongolite)
library(dplyr)
library(stringr)

######################### Read & Insert Data to MongoDB ########################


# STEP 1:
# Import a vector containing all the paths 
vec_ = dir(path = "C:\\REDIS_MARIA\\BIKES_DATASET\\BIKES", pattern = "\\.json$", 
           full.names = TRUE, recursive = TRUE)
# Vector as a list
vec_1 = as.list(vec_)

# STEP 2:
# Open the Mongo "Initial" Collection 
m <- mongo(collection = "Initial",  db = "ERGASIAMONGO", url = "mongodb://localhost")

# STEP 3: 
# Insert the Json files in the "Initial" Collection
for(i in  1:length(vec_1)){
  m$insert(fromJSON(readLines(vec_1[[i]], warn = F)))
}

# STEP 4:
# Create DataFrame
initial_df = m$find("{}")
View(initial_df)

df <- initial_df

l <- length(df$query[,1])


############################# CLEANING FUNCTION ################################

clean <- function(df1){
  
  for (i in 1:l){
    if(df1$ad_data$Price[i] == 'Askforprice') {
      df1$ad_data$Price[i] <- NA
    }
    else {
      df1$ad_data$Price[i] <- (gsub('\\D+','', df1$ad_data$Price[i])) #as.numeric
    }
    if (!is.na(df1$ad_data$Price[i])==TRUE){
      if (df1$ad_data$Price[i] < 100){
        df1$ad_data$Price[i] <- NA
      }
    }}
  df1$ad_data$Price <- as.numeric(df1$ad_data$Price)
  df1$ad_data$Mileage<- as.numeric(gsub("[,km]", "", df1$ad_data$Mileage))
  
  RegistrationYear <- as.numeric(str_sub(df1$ad_data$Registration,-4))
  
  for (i in 1:l){
    if (RegistrationYear[i] < 1910){
      df1$ad_data$Registration[i] <- NA
      df1$Age[i] <- NA
    }
    else{
      df1$Age[i] <- 2022-RegistrationYear[i]
    }
  }
  
  for (i in 1:l){
    if(grepl("Negotiable",df1$metadata$model[i]) == TRUE){
      df1$Negotiable[i] <- TRUE
    }
    else {
      df1$Negotiable[i] <- FALSE
    }
  }
  
  return(df1)
}


df <- clean(df)
View(df)

# INSERT CLEAN DATA TO MONGODB

tnew <- mongo(collection = "Cleaned",  db = "ERGASIAMONGO", url = "mongodb://localhost")
tnew$insert(df)