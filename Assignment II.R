# Exercise 1
# (a)
tree_height <- c(runif(999, max = 30, min = 2)) # tree height in meters
noise <- rnorm(999, mean = 0.05, sd = 0.02)
water_consumption <- 0.01 * tree_height + noise # water consumption in meters cubed
tree.df <- data.frame(`Height` = tree_height,
                      `Water Consumption` = water_consumption)

# (b)
tree.consump.lm <- lm(Water.Consumption ~ Height, data=tree.df) 
summary(tree.consump.lm)

# (c)
outlier_point <- c(30, -50) # some tree donates 100 cubic meters of water
tree.outlier.df <- rbind(tree.df, outlier_point)
tree.outlier.lm <- lm(Water.Consumption ~ Height, data=tree.outlier.df) 
summary(tree.outlier.lm)

# (d)
plot(tree.df$Height, tree.df$Water.Consumption,
     pch = 16, cex = 0.2, xlab = "Tree height (m)", ylab = "Water consumption (m³)")
abline(tree.consump.lm, col = "red")
abline(tree.outlier.lm, col = "blue")
legend("topleft", inset = .05, title = "Regression lines", c("w/o outlier", "with outlier"), col=c("red", "blue"), lty=1, cex=0.8)

# Exercise 2
library(Matching)
library(arm)
data("lalonde")

lin_est <- function(coefs, params) {
  est = coefs[1] +
        coefs[2] * params[1] + # age
        coefs[3] * params[2] + # educ
        coefs[4] * params[3] + # re74
        coefs[5] * params[4] + # re75
        coefs[6] * params[2] * params[3] + # educ:re74
        coefs[7] * params[2] * params[4] + # educ:re75
        coefs[8] * params[1] * params[3] + # age:re74
        coefs[9] * params[1] * params[4] + # age:re75
        coefs[10] * params[1] * params[1] + # age:re75
        coefs[11] * params[3] * params[4] # re74:re75
  return(est)
}


cntrl.idx <- which(lalonde$treat == 0)
lalonde.cntrl <- lalonde[cntrl.idx, ]

educ.q <- quantile(lalonde.cntrl$educ, c(0.5, 0.75))
re74.q <- quantile(lalonde.cntrl$re74, c(0.5, 0.75))
re75.q <- quantile(lalonde.cntrl$re75, c(0.5, 0.75))

re78.lm <- lm(re78 ~ age + educ + re74 + re75 + I(educ*re74) + I(educ*re75)
              + I(age*re74) + I(age*re75) + I(age*age) + I(re74*re75),
              data = lalonde.cntrl)
re78.coef.sim <- sim(re78.lm, 10000)
coefs <- re78.coef.sim@coef
head(coefs)

# (a)
re78.exp.med <- matrix(0, nrow = 55, ncol = 10000)
for (age in 17:55) {
  for (i in 1:10000) {
    re78.exp.med[age, i] <-
      lin_est(coefs[i, ], c(age, educ.q[1], re74.q[1], re75.q[1]))
  }
}

conf.int.exp.med <- apply(re78.exp.med, 1, quantile, probs = c(0.025, 0.975))
conf.int.exp.med

plot(x = c(1:1), y = c(1:1), type = "n",
     xlim = c(16, 56), ylim = c(0, 10000),
     xlab = "Age (years)",
     ylab = "Revenue in year 1978, re78 ($)",
     xaxp  = c(15, 55, 4))
for (age in 17:55) {
  segments(
    x0 = age,
    y0 = conf.int.exp.med[1, age],
    x1 = age,
    y1 = conf.int.exp.med[2, age],
    lwd = 2)
}

# (b)
re78.exp.75q <- matrix(0, nrow = 55, ncol = 10000)
for (age in 17:55) {
  for (i in 1:10000) {
    re78.exp.75q[age, i] <-
      lin_est(coefs[i, ], c(age, educ.q[2], re74.q[2], re75.q[2]))
  }
}

conf.int.exp.75q <- apply(re78.exp.75q, 1, quantile, probs = c(0.025, 0.975))
conf.int.exp.75q

# (c)
sigmas <- re78.coef.sim@sigma

noise_matr <- matrix(0, ncol = 10000, nrow = 55)
for (col in 1:10000) {
  noise_matr[, col] <- t(rnorm(55, 0, sigmas[col]))
}

re78.pred.med <- re78.exp.med + noise_matr
re78.pred.med

conf.int.pred.med <- apply(re78.pred.med, 1, quantile, probs = c(0.025, 0.975))
conf.int.pred.med

# (d)
for (col in 1:10000) {
  noise_matr[, col] <- t(rnorm(55, 0, sigmas[col]))
}

re78.pred.75q <- re78.exp.75q + noise_matr
re78.pred.75q

conf.int.pred.75q <- apply(re78.pred.75q, 1, quantile, probs = c(0.025, 0.975))
conf.int.pred.75q

plot(x = c(1:1), y = c(1:1), type = "n",
     xlim = c(16, 56), ylim = c(-10000, 20000),
     xlab = "Age (years)",
     ylab = "Revenue in year 1978, re78 ($)",
     xaxp  = c(15, 55, 4))
for (age in 17:55) {
  segments(
    x0 = age,
    y0 = conf.int.pred.75q[1, age],
    x1 = age,
    y1 = conf.int.pred.75q[2, age],
    lwd = 2)
}

# Exercise 3
install.packages("plyr")
library(plyr)
library(boot)

PlantGrowth
trt2.idx <- which(PlantGrowth$group == "trt2")
plant.growth <- PlantGrowth[-trt2.idx, ]
levels(plant.growth$group)
plant.growth$group <- revalue(plant.growth$group,
                              c("ctrl" = 0, "trt1" = 1))

plant.weight.lm <- lm(weight ~ group, data = plant.growth)
summary(plant.weight.lm)
confint(lm(weight ~ group, data = plant.growth))
summary(lm(weight ~ group, data = plant.growth))

boot.fn <- function(data, index) {
  return(coef(lm(weight ~ group,data = data, subset = index)))
}
boot.plant.coef <- boot(plant.growth, boot.fn, 10000)
boot.plant.coef.low <- boot(plant.growth, boot.fn, 100)
quantile(boot.plant.coef$t[, 1], c(0.025, 0.975))
quantile(boot.plant.coef$t[, 2], c(0.025, 0.975))

plot(density(rnorm(50000000, -0.3710, 0.3114)), type = "l", col = "red", lwd = 3,
     xlab = "Slope of regression line")
lines(density(boot.plant.coef.low$t[, 2]), col = "green", lwd = 3)
lines(density(boot.plant.coef$t[, 2]), col = "blue", lwd = 3)
legend("topleft", inset = .05, title = "Slope distributions",
       c("analytical", "bootstrapped, n=100", "bootstrapped, n=10k"),
       col=c("red", "green", "blue"), lty=1, cex=0.8)

# Exercise 4
r.squared <- function(y.act, y.pred) {
  y.mean = mean(y.pred)
  SSR = sum((y.act - y.pred)^2)
  SST = sum((y.act - y.mean)^2)
  return(1 - SSR / SST)
}

w.pred <- predict(plant.weight.lm, data = plant.growth)
plant.growth$weight
r.squared(plant.growth$weight, w.pred)

# Exercise 5
library(foreign)
install.packages("scales")
library(scales) # for transparent color
data <- read.dta("nsw.dta")
head(data)

treat.prob.glm <- glm(treat ~ age + education + black + hispanic + married + nodegree + re75,
                      data = data, family = 'binomial')
treat.idx <- which(data$treat == 1)
ctrl.idx <- which(data$treat == 0)
prob.pred <- predict(treat.prob.glm, type = 'response')
prob.pred

treat.hist <- hist(prob.pred[treat.idx], 100)
ctrl.hist <- hist(prob.pred[ctrl.idx], 100)
plot(ctrl.hist, col = alpha("blue", 0.4), xlab = "Probability of treatment")  
plot(treat.hist, col = alpha("red", 0.3), add = T)
legend("topright", inset = .05, title = "Assigned group",
       c("treatment", "control"),
       fill = c(alpha("red", 0.3), alpha("blue", 0.4)), cex = 0.8)

length(treat.idx)
length(ctrl.idx)
