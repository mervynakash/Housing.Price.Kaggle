set.seed(123)
setwd("E:/Kaggle/Housing Price/")

# load("HousingClean.RData")
load("HouseEDA_data.RData")

library(glmnet)
library(Matrix)
library(dplyr)

housetrain$logSalePrice <- log10(housetrain$SalePrice)

housetrainmat <- sparse.model.matrix(logSalePrice~., data = housetrain %>% select(-SalePrice))
housetestmat <- sparse.model.matrix(~., data = housetest)

#========== Lasso Reguralization ===========#
lassofit <- cv.glmnet(x = housetrainmat, y = housetrain$logSalePrice, family = "gaussian",
                   alpha = 1, type.measure = "mse")
lassopred <- predict(lassofit, housetestmat,s = lassofit$lambda.1se)
lassopred <- as.vector(lassopred)

lassopred2 <- predict(lassofit, housetestmat, s = lassofit$lambda.min)
lassopred2 <- as.vector(lassopred2)
lassopred2_new <- 10^lassopred2

lasso_df <- data.frame(ID = test$Id, SalePrice = lassopred2_new)

write.csv(lasso_df, file = "Lasso_PDM.csv", row.names = F)


#=========== Ridge Reguralization ==========#
ridgefit <- cv.glmnet(x = housetrainmat, y = housetrain$logSalePrice, family = "gaussian",
                      alpha = 0, type.measure = "mse")
ridgepred <- predict(ridgefit, housetestmat, s = ridgefit$lambda.1se)
ridgepred2 <- predict(ridgefit, housetestmat, s = ridgefit$lambda.min)
ridgepred <- as.vector(ridgepred)
ridgepred2 <- as.vector(ridgepred2)

ridgepred2_new <- 10^ridgepred2

ridge_df <- data.frame(ID = test$Id, SalePrice = ridgepred2_new)

write.csv(ridge_df, "Ridge_PDM.csv", row.names = F)

#=========== Elastic Net ===================#
elasticnet <- cv.glmnet(x = housetrainmat, y = housetrain$logSalePrice, family = "gaussian",
                        alpha = 0.5, type.measure = "mse")
elasticpred <- predict(elasticnet, housetestmat, s = elasticnet$lambda.1se)
elasticpred <- as.vector(elasticpred)

elasticpred2 <- predict(elasticnet, housetestmat, s = elasticnet$lambda.min)
elasticpred2 <- as.vector(elasticpred2)

elasticpred2_new <- 10^elasticpred2

elastic_df <- data.frame(ID = test$Id, SalePrice = elasticpred2_new)

write.csv(elastic_df, file = "ElasticNet_PDM.csv", row.names = F)
