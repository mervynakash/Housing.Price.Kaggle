set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(caret)
library(class)

control <- trainControl(method = "repeatedcv", repeats = 3)

modelknn <- train(SalePrice~., data = housetrain, method = "knn", tuneLength = 50, 
                  trControl = control)

knnpred <- predict(modelknn, housetest)

knn_df <- data.frame(ID = test$Id, SalePrice = knnpred)

write.csv(knn_df, file = "knn.csv", row.names = F)
