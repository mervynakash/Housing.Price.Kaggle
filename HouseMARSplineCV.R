set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(earth)

modelmarscv <- earth(SalePrice~., data = housetrain, pmethod = "cv", trace = .5,
                     nfold = 10, ncross = 3, keepxy = T)

marscvpred <- predict(modelmarscv, housetest)
marscvpred <- as.vector(marscvpred)

marscv_df <- data.frame(ID = test$Id, SalePrice = marscvpred)

write.csv(marscv_df, file = "MARSpline-CV.csv", row.names = F)
