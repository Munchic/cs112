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

