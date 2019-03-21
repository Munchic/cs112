library(foreign)
library(boot)
data <- read.dta("nsw.dta")
nsw.lm <- lm(re78 ~ treat + age + education + black + hispanic + married + nodegree + re75, data = data)
confint(nsw.lm)

boot.fn <- function(data, idx) return(data[idx, ])
boot.nsw.coef <- boot(plant.growth, boot.fn, 10000)