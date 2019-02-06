library(Matching)
log_regr = glm(treat ~ age + educ + u75 + age:lalonde$educ, family = "binomial")
summary(log_regr)
log_regr$fitted.values


hist(predict(log_regr, type = "response")) # newdata
x = (-50:50)/10
y = exp(-x) / (1 + exp(-x) )
plot(x,y)
