# Imagine Sandy has an age of 15 and a weight of 15. He gets the treatment.


# Now imagine that there are two potential matches for Sandy -- there's Control 1, who has an age of 10 and weight of 10, and Control 2, who has an age of 20 and a weight of 25. Which is the better match? Are you sure?


# What do you think would be the best way to match if Control 2 was (20, 20) instead of (20, 25)? What if Control 2 was (15, 25)? Should the matching algorithm depend at all upon the scale of these variables (age in years vs. days, weight in kg or grams)?


# Come to class ready to discuss your thoughts.

library(Matching)
?Match
  
# Replication of Dehejia and Wahba psid3 model
#
# Dehejia, Rajeev and Sadek Wahba. 1999.``Causal Effects in
# Non-Experimental Studies: Re-Evaluating the Evaluation of Training
# Programs.''Journal of the American Statistical Association 94 (448):
# 1053-1062.

data(lalonde)

#
# Estimate the propensity model
#
glm1  <- glm(treat~age + I(age^2) + educ + I(educ^2) + black +
               hisp + married + nodegr + re74  + I(re74^2) + re75 + I(re75^2) +
               u74 + u75, family=binomial, data=lalonde)
glm1

#
#save data objects
#
X  <- glm1$fitted
Y  <- lalonde$re78
Tr  <- lalonde$treat

#
# one-to-one matching with replacement (the "M=1" option).
# Estimating the treatment effect on the treated (the "estimand" option defaults to ATT).
#
rr  <- Match(Y=Y, Tr=Tr, X=X, M=1);
summary(rr)

# Let's check the covariate balance
# 'nboots' is set to small values in the interest of speed.
# Please increase to at least 500 each for publication quality p-values.  
mb  <- MatchBalance(treat~age + I(age^2) + educ + I(educ^2) + black +
                      hisp + married + nodegr + re74  + I(re74^2) + re75 + I(re75^2) +
                      u74 + u75, data=lalonde, match.out=rr, nboots=10)
mb
