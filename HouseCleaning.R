set.seed(123)
setwd("E:/Kaggle/Housing Price/")

library(caret)
library(dplyr)
library(randomForest)
library(earth)
library(xgboost)
library(Matrix)
library(rpart)
library(glmnet)
library(adabag)
library(mice)

train <- read.csv("train.csv")
test <- read.csv("test.csv")

nrow(train)
str(train)
colSums(is.na(train))

#===================== Missing Data Imputation =======================================#
train$Alley <- NULL
train$FireplaceQu <- NULL
train$PoolQC <- NULL
train$Fence <- NULL
train$MiscFeature <- NULL

test$Alley <- NULL
test$FireplaceQu <- NULL
test$PoolQC <- NULL
test$Fence <- NULL
test$MiscFeature <- NULL

temptrain <- mice(train, m = 5, method = "rf", maxit = 10)
summary(temptrain)

trainnew <- complete(temptrain, 1)


temptest <- mice(test, m = 5, method = "rf", maxit = 10)
testnew <- complete(temptest, 1)


sd <- names(which(sapply(testnew,is.factor)))
f <- c()
for(i in sd){
  f <- c(f, length(levels(testnew[,i])))
}
sd[which(f == 1)]

housedum <- rbind(trainnew %>% select(-SalePrice), testnew)

housedum$Utilities <- NULL
housedumnew <-  dummyVars(~., data = housedum)
housedumpred <- predict(housedumnew,housedum)

trainnewpred <- housedumpred[1:nrow(trainnew),]
testnewpred <- housedumpred[-(1:nrow(trainnew)),]

prin_train <- prcomp(trainnewpred, scale. = T)
names(prin_train)
prin_train$center
prin_train$scale
dim(prin_train$x)

std_dev <- prin_train$sdev
pr_var <- std_dev^2

prop_varex <- pr_var/sum(pr_var)
prop_varex[1:10]

plot(prop_varex, xlab = "Principal Component", ylab = "Proportion of Variance Explained",
     type = "b")

plot(cumsum(prop_varex), xlab = "Principal Component", 
     ylab = "Cumulative Proportion of Variance Explained", type = "b")

housetrain <- data.frame(SalePrice = train$SalePrice, prin_train$x)
housetrain <- housetrain[,1:151]

housetest <- predict(prin_train, newdata = testnewpred)
housetest <- as.data.frame(housetest)
housetest <- housetest[,1:150]

save(list = ls(all.names = T), file = "HousingClean.RData", envir = .GlobalEnv)
