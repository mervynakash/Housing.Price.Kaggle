set.seed(123)
setwd("E:/Kaggle/Housing Price/")

# load("HousingClean.RData")
load("HouseEDA_data.RData")

library(earth)
library(dplyr)

housetrain$logSalePrice <- log10(housetrain$SalePrice)

modelmars <- earth(logSalePrice~., data = housetrain %>% select(-SalePrice), pmethod = "forward", trace = 2)

marsforpred <- as.vector(predict(modelmars, housetest))

marsforpred_new <- 10^marsforpred

marsfor_df <- data.frame(ID = test$Id, SalePrice = marsforpred_new)

# write.csv(marsfor_df, file = "MARSpline-Forward.csv", row.names = F)

write.csv(marsfor_df, file = "MARSpline-Forward_PDM.csv", row.names = F)
