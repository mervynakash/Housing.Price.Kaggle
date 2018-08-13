set.seed(123)
setwd("E:/Kaggle/Housing Price/")

library(corrplot)
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

# Imputing Missing values:
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

load("HouseEDA_data.RData")

num_col <- sapply(housetrain, is.numeric)
num_col <- names(num_col[num_col])

corrplot(cor(housetrain[,num_col]), method = "ellipse")
mat_num <- as.data.frame(cor(housetrain[,num_col]))

cor_sale <- row.names(mat_num[which(abs(mat_num$SalePrice) > 0.5),])

cor_length <- c()
for(i in colnames(mat_num)){
  cor_length <- c(cor_length, length(abs(mat_num[,i])[abs(mat_num[,i] > 0.5)]))
}
cor_name <- colnames(mat_num)
names(cor_length) <- cor_name

cor_remove <- names(cor_length[cor_length >= 10])

cor_remove <- cor_remove[!cor_remove %in% cor_sale]

housetrain[,cor_remove] <- NULL

#====================== Outlier Detection and Imputing ============================#
# out_impute <- function(x){
#   qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
#   caps <- quantile(x, probs=c(.05, .95), na.rm = T)
#   H <- 1.5 * IQR(x, na.rm = T)
#   x[x < (qnt[1] - H)] <- caps[1]
#   x[x > (qnt[2] + H)] <- caps[2]
#   return(x)
# }
# 
# un_len <- sapply(housetrain[,c(num_col)], function(x) length(unique(x)))
# 
# cont_col <- names(un_len[un_len > 20])
# 
# new_df <- sapply(housetrain[,cont_col], out_impute)

#=========================== FEATURE ENGINEERING ===================================#


# GrLivArea
housetrain$logGrLivArea <- log10(housetrain$GrLivArea)
housetest$logGrLivArea <- log10(housetest$GrLivArea)

housetrain$GrLivArea <- NULL
housetest$GrLivArea <- NULL

# GarageArea
housetrain$logGarageArea <- log10(housetrain$GarageArea + 1)
housetest$logGarageArea <- log10(housetest$GarageArea + 1)

housetrain$GarageArea <- NULL
housetest$GarageArea <- NULL


