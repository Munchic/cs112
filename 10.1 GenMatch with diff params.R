library(Matching)

fake <- read.csv("https://tinyurl.com/yxzo52ez")
head(fake)

# Perform multivariate matching with replacement, matching on all pretreatment variables
# Estimate...  1598.5 AI SE......  989.53 
# Worst balance: p = 0.25153
X.1 = cbind(fake$age, fake$educ, fake$black, fake$hisp, fake$married, fake$nodegr,
            fake$re74, fake$re75, fake$u74, fake$u75)
Tr = fake$treat
Y = fake$re78

genout.1 <- GenMatch(Tr = Tr, X = X.1, estimand = "ATT",
                     pop.size = 10, max.generations = 10,
                     wait.generations = 4)
mout.1 <- Match(Tr = Tr, X = X.1, estimand = "ATT", Weight.matrix = genout.1)
mb.1 <- MatchBalance(fake$treat ~ fake$age + fake$educ + fake$black + fake$hisp +
                     fake$married + fake$nodegr + fake$re74 + fake$re75 + fake$u74 +
                     fake$u75, match.out = mout.1)

mout.1.tr <- Match(Tr = Tr, Y = Y, X = X.1, estimand = "ATT", Weight.matrix = genout.1)

# Same as 1 above, except include interactions for age*educ, age*black, married*black, & married*educ --- don’t forget to set the data set w/ the prefix fake$
X.2 = cbind(fake$age, fake$educ, fake$black, fake$hisp, fake$married, fake$nodegr,
            fake$re74, fake$re75, fake$u74, fake$u75,
            fake$age*fake$educ, fake$age*fake$black, fake$married*fake$black, fake$married*fake$educ)

genout.2 <- GenMatch(Tr = Tr, X = X.2, estimand = "ATT",
                     pop.size = 10, max.generations = 10,
                     wait.generations = 4)

mout.2 <- Match(Tr = Tr, X = X.2, estimand = "ATT", Weight.matrix = genout.2)
mb.2 <- MatchBalance(fake$treat ~ fake$age + fake$educ + fake$black + fake$hisp +
                       fake$married + fake$nodegr + fake$re74 + fake$re75 + fake$u74 +
                       fake$u75 + fake$age:fake$educ + fake$age:fake$black +
                       fake$married:fake$black + fake$married:fake$educ, match.out = mout.2)

?GenMatch
?lapply


library(Matching)

lalonde$age


by_three <- function(x) {
  return(x*3)
}

a <- c(1, 2, 3, 4)
lapply(lalonde$age, by_three)
