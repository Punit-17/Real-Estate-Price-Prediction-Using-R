setwd("D:\\IITK DATA ANALYTICS\\Final Projects\\Real Estate Price Prediction Using R")
getwd()

train_data = read.csv("housing_train.csv",stringsAsFactors = F)
test_data = read.csv("housing_test.csv",stringsAsFactors = F)

test_data$Price = NA

train_data$data = 'train'     #setting an identifier column to separate the 2 data sets after
test_data$data = 'test'       # the data preparation


all_data = rbind(train_data,test_data)  # bind the train and test data sets for data prep

library(dplyr)

glimpse(all_data)
names(all_data)
table(all_data$CouncilArea)

all_data$Address = NULL     # excluding this column as it doesn't have a affect on the decision
all_data$Method = NULL      # excluding this column as it doesn't have a affect on the decision
all_data$SellerG = NULL     # excluding this column as it doesn't have a affect on the decision
all_data$Postcode = NULL    # excluding this column as it doesn't have a affect on the decision

glimpse(all_data)

# create dummies function code - to convert categorical to numeric

CreateDummies = function(data,var,freq_cutoff=0){
  t = table(data[,var])
  t = t[t>freq_cutoff]
  t = sort(t)
  
  for (cat in names(t)) {
    name = paste(var,cat,sep = "_")
    name = gsub(" ","",name)
    name = gsub("-","_",name)
    name = gsub("\\?","Q",name)
    name = gsub("<","LT_",name)
    name = gsub("\\+","",name)
    
    data[,name] = as.numeric(data[,var]==cat)
  }
  
  data[,var]=NULL
  return(data)
}


# use function on categorical variable

glimpse(all_data)

all_data = CreateDummies(all_data,"Suburb",)
all_data = CreateDummies(all_data, "Type",)
all_data = CreateDummies(all_data, "CouncilArea",)


#check for NA Values

lapply(all_data,function(all_data) sum(is.na(all_data)))


names(all_data)

for (col in names(all_data)) # to replace NA values with mean of train data
{
  if (sum(is.na(all_data[,col])) > 0 & !(col %in% c("data","Price")))
  {
    all_data[is.na(all_data[,col]),col] = mean(all_data[all_data$data == 'train',col], na.rm = T)
    
  }
  
}

lapply(all_data,function(all_data) sum(is.na(all_data)))

glimpse(all_data)


# separate the data sets into train and test
train_data = all_data %>% filter(data == 'train') %>% select(-data)
test_data = all_data %>% filter(data == 'test') %>% select(-data,-Price)


# splitting the data into 70-30 for testing

set.seed(2)
s = sample(1:nrow(train_data),0.7*nrow(train_data))
train_data1 = train_data[s,]
train_data2 = train_data[-s,]

# Building a Decision Tree
#library(ggplot2)
#library(tree)
#library(car)

#rp.tree = tree(Price~.,data = train_data1)
#vif(rp.tree)

# View Tree in text
#rp.tree

#Visualize tree
#plot(rp.tree)
#text(rp.tree)

# Performance on validation set
#val.price = predict(rp.tree, data = train_data2)
#val.price

#rmse_price =((val.price)-(train_data2$Price))^2 %>% mean() %>% sqrt()
#rmse_price
#212467/rmse_price

# Final model and test performance on entire test data
#rp.tree.final = tree(Price~.,data = train_data)
#test.pred = predict(rp.tree.final, newdata = test_data)

#write.csv(test.pred,"Punit_Alkunte_P1_P2.csv", row.names = F)



###################### LINEAR REGRESSION ###################
#############################################################
library(car)

fit = lm(Price~.-Suburb_BentleighEast-Suburb_Reservoir-Type_h-CouncilArea_ 
         -Distance
         ,data = train_data1)
vif(fit)
sort(vif(fit), decreasing = T)

#summary(fit)

#fit = step(fit)

#summary(fit)

#formula(fit)

fit = lm(Price~.-Suburb_BentleighEast-Suburb_Reservoir-Type_h-CouncilArea_ 
         -Distance
         ,data = train_data1)

summary(fit)


# model prediction for 70-30 data
library(dplyr)

val.predict = predict(fit,newdata = train_data2)
val.predict

errors = train_data2$Price-val.predict # RMSE VALUE
errors
rmse.val = errors**2 %>% mean() %>% sqrt()   # RMSE VALUE
rmse.val

# Project criteria score 
score = 212467/rmse.val
score


#Model Prediction for Entire data

fit.final = lm(Price~.-Suburb_BentleighEast-Suburb_Reservoir-Type_h-CouncilArea_ 
               -Distance
               , data = train_data)
vif(fit.final)

sort(vif(fit.final),decreasing = T)

summary(fit.final)

#
final_values = predict(fit.final, newdata = test_data)
final_values

write.csv(final_values,"Punit_Alkunte_P1_P2.csv",row.names = F)



## diagnosis

plot(fit.final, 1) #residual vs fitted values - non linearity in the data exists or not.
plot(fit.final, 2) # errors are normal or not.
plot(fit.final, 3) # variance is constant or not.
plot(fit.final, 4) # outliers in the data if cook's distance
