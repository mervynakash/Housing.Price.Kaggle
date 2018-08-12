set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HouseEDA_data.RData")
# load("HousingClean.RData")

library(earth)
library(dplyr)

housetrain$logSalePrice <- log10(housetrain$SalePrice)

modelmars <- earth(logSalePrice~., data = housetrain %>% select(-SalePrice), pmethod = "backward", trace = 2)

marsbackpred <- as.vector(predict(modelmars, housetest))

marsbackpred_new <- 10^marsbackpred

marsback_df <- data.frame(ID = test$Id, SalePrice = marsbackpred_new)

# write.csv(marsback_df, file = "MARSpline-Backward.csv", row.names = F)
write.csv(marsback_df, file = "MARSpline-Backward_PDM.csv", row.names = F)
