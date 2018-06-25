set.seed(123)
setwd("E:/Kaggle/Housing Price/")

load("HousingClean.RData")

library(rpart)

modeldt <- rpart(SalePrice~., data = housetrain, control = rpart.control(cp = 0), method = "anova")
printcp(modeldt)

cpval <- modeldt$cptable[which.min(modeldt$cptable[,"xerror"]),"CP"]

modeldtnew <- prune(modeldt, cp = cpval)

rpartpred <- predict(modeldtnew, housetest)

dt_df <- data.frame(ID = test$Id, SalePrice = rpartpred)

write.csv(dt_df, file = "DecisionTree.csv", row.names = F)
