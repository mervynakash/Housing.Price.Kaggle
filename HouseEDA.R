set.seed(123)
setwd("E:/Kaggle/Housing Price/")

library(dplyr)
library(Boruta)
library(rpart)
library(PDM)

train <- read.csv("E:/Kaggle/Housing Price/train.csv")
test <- read.csv("test.csv")

target <- train$SalePrice

train$SalePrice <- NULL

df <- rbind(train,test)

# Load the data from the rdata file
load("HouseClean_PDM.RData")
# df <- pdm_impute(df,20)

train <- df[1:1460,]
test <- df[1461:nrow(df),]

train$SalePrice <- target

impVar <- Boruta(SalePrice~., train, doTrace = 2)

print(impVar)

plot(impVar, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(impVar$ImpHistory),function(i)
  impVar$ImpHistory[is.finite(impVar$ImpHistory[,i]),i])
names(lz) <- colnames(impVar$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(impVar$ImpHistory), cex.axis = 0.7)

getSelectedAttributes(impVar, withTentative = F)

impVar_conf <- attStats(impVar)
print(impVar_conf)

final.impVar <- TentativeRoughFix(impVar)
print(final.impVar)

final_col <- getSelectedAttributes(final.impVar, withTentative = F)


housetrain <- train[,c(final_col)]
housetrain$SalePrice <- train$SalePrice
housetest <- test[,c(final_col)]

