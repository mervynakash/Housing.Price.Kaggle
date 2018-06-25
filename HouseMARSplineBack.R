set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(earth)

modelmars <- earth(SalePrice~., data = housetrain, pmethod = "backward", trace = 2)

marsbackpred <- as.vector(predict(modelmars, housetest))

marsback_df <- data.frame(ID = test$Id, SalePrice = marsbackpred)

write.csv(marsback_df, file = "MARSpline-Backward.csv", row.names = F)
