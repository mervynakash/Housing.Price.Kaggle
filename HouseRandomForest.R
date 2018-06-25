set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(randomForest)

mtry1 <- floor(sqrt(ncol(housetrain)-1))

modelrf <- randomForest(SalePrice~., data = housetrain, mtry = mtry1 + 1, ntree = 100)

rfpred <- predict(modelrf, housetest)

rf_df <- data.frame(ID = test$Id, SalePrice = rfpred)

write.csv(rf_df, file = "RandomForest.csv", row.names = F)
