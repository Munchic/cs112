foo <- read.csv("https://course-resources.minerva.kgi.edu/uploaded_files/mke/00086677-3767/peace.csv")
colnames(foo)
foo <- foo[, c(6:8, 11:16, 99, 50, 108, 114, 49, 63, 136, 109, 126, 48, 160, 142, 10)]

foo <- foo[c(-19, -47), ]
head(foo)
which(is.na(foo) == TRUE)

X <- cbind(foo$wartype, foo$logcost, foo$wardur, foo$factnum, 
           foo$factnum2, foo$trnsfcap, foo$untype4, 
           foo$treaty, foo$develop, foo$exp, foo$decade,
           (foo$logdead * foo$untype4))
head(X)

calc_pbs2s3 <- function(model, params) {
  coefs <- model$coefficients
  pbs2s3 <- coefs[1] * 1
  for (i in 2:length(coefs)) {
    pbs2s3 <- pbs2s3 + coefs[i] * params[i-1]
  }
    
  return(1 / (1 + exp(-pbs2s3)))
}

glm.nointer <- glm(pbs2s3 ~ wartype + logcost + wardur + factnum +
            factnum2 + trnsfcap + develop +
            exp + decade + treaty + untype4, 
            data=foo, family = binomial)
glm.logdead.untype4 <- glm(pbs2s3 ~ wartype + logcost + wardur + factnum +
                          factnum2 + trnsfcap + develop +
                          exp + decade + treaty + untype4 + I(logdead*untype4), 
                          data=foo, family = binomial)
glm.wardur.untype4 <- glm(pbs2s3 ~ wartype + logcost + wardur + factnum +
                          factnum2 + trnsfcap + develop +
                          exp + decade + treaty + untype4 + I(wardur*untype4), 
                          data=foo, family = binomial)

colnames(foo)

mean.country.encounter <- c(mean(foo$wartype), #1
                            mean(foo$logcost), #2
                            mean(foo$wardur), #3
                            mean(foo$factnum), 
                            mean(foo$factnum2),
                            mean(foo$trnsfcap),
                            mean(foo$develop),
                            mean(foo$exp),
                            mean(foo$decade),
                            mean(foo$treaty),
                            mean(foo$untype4))
                                 
mean.country.encounter

storage.nointer <- c()
storage.wardur.untype4 <- c()
storage.logdead.untype4 <- c()

for (wardur in 5:315) {
  # basic variables
  encounter <- mean.country.encounter
  encounter[3] <- wardur
  encounter[length(encounter)] <- 1
  trt.unit <- calc_pbs2s3(glm.nointer, encounter)
  encounter[length(encounter)] <- 0
  ctr.unit <- calc_pbs2s3(glm.nointer, encounter)
  storage.nointer <- c(storage.nointer, trt.unit - ctr.unit)
  
  # wardur * untype4
  encounter <- c(encounter, wardur * 1) # untype = 1
  encounter[3] <- wardur
  encounter[length(encounter) - 1] <- 1
  trt.unit <- calc_pbs2s3(glm.wardur.untype4, encounter)
  encounter[length(encounter) - 1] <- 0
  encounter[length(encounter)] <- 0 # wardur * untype4
  ctr.unit <- calc_pbs2s3(glm.wardur.untype4, encounter)
  storage.wardur.untype4 <- c(storage.wardur.untype4, trt.unit - ctr.unit)
  
  # logdead * untype4
  encounter[3] <- wardur
  encounter[length(encounter) - 1] <- 1
  encounter[length(encounter)] <- mean(foo$logdead) * 1 # logdead * untype4
  trt.unit <- calc_pbs2s3(glm.logdead.untype4, encounter)
  encounter[length(encounter) - 1] <- 0
  encounter[length(encounter)] <- 0 # logdead * untype4
  ctr.unit <- calc_pbs2s3(glm.logdead.untype4, encounter)
  storage.logdead.untype4 <- c(storage.logdead.untype4, trt.unit - ctr.unit)
}

plot(x = 5:315, y = storage.nointer, xlim = c(5, 315), ylim = c(0, 0.8), type="l", lty="dotted",
     xlab="War duration (years)", ylab="Marginal effect from untype4")
lines(x = 5:315, y = storage.wardur.untype4)
lines(x = 5:315, y = storage.logdead.untype4, col = 'red')
glm.wardur.untype4
glm.logdead.untype4


length(storage.nointer)
length(storage.wardur.untype4)

glm.nointer$coefficients
length(glm.nointer$coefficients)
length(mean.country.encounter)

predict(glm.nointer, foo)


# Task 4
head(foo)
foo <- read.csv("https://course-resources.minerva.kgi.edu/uploaded_files/mke/00086677-3767/peace.csv")
colnames(foo)
foo <- foo[, c(34, 35, 52, 6:8, 11:16, 99, 50, 108, 114, 49, 63, 124:127, 136, 109, 126, 48, 160, 142, 10)]

# remove NA
foo <- foo[complete.cases(foo), ]
which(is.na(foo) == TRUE)
head(foo)

# define treatment
Tr <- rep(0, length(foo$uncint))
Tr[which(foo$untype2==1 | foo$untype3==1 | foo$untype4==1 | foo$untype5==1)] <- 1
foo$Tr <- Tr
head(foo)

# log regr
glm.2yr <- glm(pbs2l ~ wartype + logcost + wardur + factnum +
               factnum2 + trnsfcap + develop +
               exp + decade + treaty + Tr, 
               data=foo, family = binomial)
summary(glm.2yr)
glm.5yr <- glm(pbs5l ~ wartype + logcost + wardur + factnum +
               factnum2 + trnsfcap + develop +
               exp + decade + treaty + Tr, 
               data=foo, family = binomial)
summary(glm.5yr)

encounter <- mean.country.encounter
encounter[length(encounter)] <- 1
trt.unit <- encounter
encounter[length(encounter)] <- 0
ctr.unit <- encounter
# 2 yr
calc_pbs2s3(glm.2yr, trt.unit) - calc_pbs2s3(glm.2yr, ctr.unit)
# 5 yr
calc_pbs2s3(glm.5yr, trt.unit) - calc_pbs2s3(glm.5yr, ctr.unit)

library(Matching)

# propensity score matching
prop.sc <- glm(Tr ~ wartype + logcost + wardur + factnum +
                 factnum2 + trnsfcap + develop +
                 exp + decade + treaty, 
               data=foo, family = binomial)
Tr <- foo$Tr
X <- prop.sc$fitted
Y2 <- foo$pbs2l
Y5 <- foo$pbs5l


mout.2yr <- Match(Tr=Tr, X=X, Y=Y2, BiasAdjust = TRUE)
summary(mout.2yr)

mout.5yr <- Match(Tr=Tr, X=X, Y=Y5, BiasAdjust = TRUE)
summary(mout.5yr)

MatchBalance(Tr ~ wartype + logcost + wardur + factnum +
               factnum2 + trnsfcap + develop +
               exp + decade + treaty, 
             data=foo, match.out = mout.2yr, nboots = 1000)

foo$untype4


# genetic matching
Tr <- foo$Tr
X <- cbind(foo$wartype, foo$logcost, foo$wardur, foo$factnum,
            foo$factnum2, foo$trnsfcap, foo$develop, foo$exp,
            foo$decade, foo$treaty)

genout <- GenMatch(Tr=Tr, X=X, pop.size = 250, max.generations = 30)

mout <- Match(Tr=Tr, X=X, Weight.matrix = genout)
MatchBalance(Tr ~ wartype + logcost + wardur + factnum +
               factnum2 + trnsfcap + develop +
               exp + decade + treaty, 
             data=foo, match.out = mout)

mout.2yr <- Match(Tr=Tr, X=X, Y=Y2, Weight.matrix = genout, BiasAdjust = TRUE)
summary(mout.2yr)

mout.2yr <- Match(Tr=Tr, X=X, Y=Y5, Weight.matrix = genout, BiasAdjust = TRUE)
summary(mout.5yr)
