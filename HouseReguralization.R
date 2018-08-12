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

lassopred2 <- predict(lassofit, housetestmat, s = lassofit$lambda.min)
lassopred2 <- as.vector(lassopred2)

lasso_df <- data.frame(ID = test$Id, SalePrice = lassopred2)

write.csv(lasso_df, file = "Lasso.csv", row.names = F)


#=========== Ridge Reguralization ==========#
ridgefit <- cv.glmnet(x = housetrainmat, y = housetrain$SalePrice, family = "gaussian",
                      alpha = 0, type.measure = "mse")
ridgepred <- predict(ridgefit, housetestmat, s = ridgefit$lambda.1se)
ridgepred2 <- predict(ridgefit, housetestmat, s = ridgefit$lambda.min)
ridgepred <- as.vector(ridgepred)
ridgepred2 <- as.vector(ridgepred2)

ridge_df <- data.frame(ID = test$Id, SalePrice = ridgepred2)

write.csv(ridge_df, "Ridge.csv", row.names = F)

#=========== Elastic Net ===================#
elasticnet <- cv.glmnet(x = housetrainmat, y = housetrain$SalePrice, family = "gaussian",
                        alpha = 0.5, type.measure = "mse")
elasticpred <- predict(elasticnet, housetestmat, s = elasticnet$lambda.1se)
elasticpred <- as.vector(elasticpred)

elasticpred2 <- predict(elasticnet, housetestmat, s = elasticnet$lambda.min)
elasticpred2 <- as.vector(elasticpred2)

elastic_df <- data.frame(ID = test$Id, SalePrice = elasticpred2)

write.csv(elastic_df, file = "ElasticNet.csv", row.names = F)
