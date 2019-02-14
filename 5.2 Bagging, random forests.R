library(Matching)
data(lalonde)
library(tree)


tree.unemp <- tree(u75 ~ re78, data = lalonde)
summary(tree.unemp)
head(lalonde$u75)
tree.unemp
plot(tree.unemp)
text(tree.unemp)


tree.unemp.train.pred <- predict(tree.unemp, lalonde)
table(tree.unemp.train.pred, lalonde$u75)

  
  
library(ISLR)
attach(Carseats)
High = ifelse(Sales <= 8, "No", "Yes")
Carseats <- data.frame(Carseats, High)
tree.carseats <- tree(High ~ . -Sales, data = Carseats)
summary(tree.carseats)


install.packages("randomForest")
library(MASS)
library(randomForest)
set.seed(1)

bag.boston <- randomForest(medv ~ ., data = Boston, subset = train, mtry = 13, importance = TRUE)
bag.boston
boston.test <- 

yhat.bag <- predict(bag.boston, newdata = Boston[-train, ])
plot(yhat.bag, boston.test)
