library(foreign)
library(arm)
data <- read.dta("4.1 turnout.dta")
head(data)

get_turnout_prob <- function(coefs, vector_of_characteristics) {
  logit <- coefs[1] + vector_of_characteristics[1]*coefs[2] +
    vector_of_characteristics[2]*coefs[3] +
    vector_of_characteristics[3]*coefs[4] + 
    vector_of_characteristics[4]*coefs[5] +
    vector_of_characteristics[5]*coefs[6]
  
  return(exp(logit) / (1 + exp(logit)))
}

lm2 <- glm(formula = turnout ~ white + age + educate + income + agesqrd,
           family = "binomial",
           data = data)

sum(coef(lm2) * c(1, 0, 38, 12, 4, 14.44))
coef(lm2)

get_turnout_prob(coef(lm2), c(0, 38, 12, 4, 14.44))
# --> 74%

get_turnout_prob(coef(lm2), c(0, 38, 20, 4, 14.44))
# --> 92%

white_mean <- mean(data$white)
income_mean <- mean(data$income)

that_avg_dude <- c(white_mean, 38, 16, income_mean, 14.44)
get_turnout_prob(coef(lm2), that_avg_dude)

lm2.sim <- sim(lm2, 1000)

storage <- c()
for (i in 1:1000) {
  storage[i] <- get_turnout_prob(lm2.sim@coef[i, ], that_avg_dude)
}
head(storage)
quantile(storage, probs = c(0.005, 0.995))


storage_df_grad <- matrix(0, nrow = 1000, ncol = 78)
for (age in 18:95) {
  for (i in 1:1000) {
    storage_df_grad[i, age - 17] <- get_turnout_prob(lm2.sim@coef[i, ], c(white_mean, age, 16, income_mean, 14.44))
  }
}

lm2.sim@coef[100, ]

storage_df_hs <- matrix(0, nrow = 1000, ncol = 78)

for (age in 18:95) {
  for (i in 1:1000) {
    storage_df_hs[i, age - 17] <- get_turnout_prob(lm2.sim@coef[i, ], c(white_mean, age, 12, income_mean, 14.44))
  }
}

head(storage_df)
conf.intervals.grad <- apply(storage_df_grad, 2, quantile, probs = c(0.005, 0.995))
conf.intervals.hs <- apply(storage_df_hs, 2, quantile, probs = c(0.005, 0.995))

plot(x = c(1:100), y = c(1:100), type = "n", xlim = c(18,95), ylim = c(0,1))

for (age in 18:95) {
  segments(
    x0 = age,
    y0 = conf.intervals.grad[1, age - 17],
    x1 = age,
    y1 = conf.intervals.grad[2, age - 17],
    lwd = 2)
} 

for (age in 18:95) {
  segments(
    x0 = age,
    y0 = conf.intervals.hs[1, age - 17],
    x1 = age,
    y1 = conf.intervals.hs[2, age - 17],
    lwd = 2)
} 


