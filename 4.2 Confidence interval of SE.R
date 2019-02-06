library(Matching)
library(arm)

x <- lalonde$treat
y <- lalonde$re78

reg1 <- lm(y ~ x)

# this gives you the regression results
summary(reg1)

# this gives you just the results relevant to coefficients
summary(reg1)$coef

# this gives you the key result (the standard error for the ‘treatment’ variable)
summary(reg1)$coef[4]

reg1.sim <- sim(reg1, 10000)

reg1.st.err <- reg1.sim@sigma
quantile(reg1.st.err, probs = c(0.005, 0.995))
