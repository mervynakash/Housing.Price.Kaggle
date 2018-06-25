set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

modellm <- lm(SalePrice~., data = housetrain)

lmpred <- predict(modellm, housetest)

lm_df <- data.frame(ID = test$Id, SalePrice = lmpred)

write.csv(lm_df, file = "LinearReg.csv", row.names = F)
