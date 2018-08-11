set.seed(123)
setwd("E:/Kaggle/Housing Price/")

# load("HousingClean.RData")
load("HouseEDA_data.RData")

library(earth)

modelmars <- earth(SalePrice~., data = housetrain, pmethod = "forward", trace = 2)

marsforpred <- as.vector(predict(modelmars, housetest))

marsfor_df <- data.frame(ID = test$Id, SalePrice = marsforpred)

# write.csv(marsfor_df, file = "MARSpline-Forward.csv", row.names = F)

write.csv(marsfor_df, file = "MARSpline-Forward_PDM.csv", row.names = F)
