set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(glmnet)
library(Matrix)

housetrainmat <- sparse.model.matrix(SalePrice~., data = housetrain)
housetestmat <- sparse.model.matrix(~., data = housetest)

#========== Lasso Reguralization ===========#
lassofit <- cv.glmnet(x = housetrainmat, y = housetrain$SalePrice, family = "gaussian",
                   alpha = 1, type.measure = "mse")
lassopred <- predict(lassofit, housetestmat,s = lassofit$lambda.1se)
lassopred <- as.vector(lassopred)
lasso_df <- data.frame(ID = test$Id, SalePrice = lassopred)

write.csv(lasso_df, file = "Lasso.csv", row.names = F)


#=========== Ridge Reguralization ==========#
ridgefit <- cv.glmnet(x = housetrainmat, y = housetrain$SalePrice, family = "gaussian",
                      alpha = 0, type.measure = "mse")
ridgepred <- predict(ridgefit, housetestmat, s = ridgefit$lambda.1se)
ridgepred <- as.vector(ridgepred)

ridge_df <- data.frame(ID = test$Id, SalePrice = ridgepred)

write.csv(ridge_df, "Ridge.csv", row.names = F)
