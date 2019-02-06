library(Matching)
library(boot)
data("lalonde")

head(lalonde)

treat.grp <- which(lalonde$treat == 1)
cntrl.grp <- which(lalonde$treat == 0)

re78.treat <- lalonde$re78[treat.grp]
re78.cntrl <- lalonde$re78[cntrl.grp]

boot.fn <- function(data, idx) return(mean(data[idx]))
boot.re78.treat <- boot(re78.treat, boot.fn, 10000)
boot.re78.cntrl <- boot(re78.cntrl, boot.fn, 10000)

head(boot.re78.treat$t)
head(boot.re78.cntrl$t)

treat.effect <- boot.re78.treat$t - boot.re78.cntrl$t
quantile(treat.effect, probs = c(0.025, 0.975))                        
