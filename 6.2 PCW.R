obs.lalonde <- read.csv("observational_lalonde.csv")
head(obs.lalonde)
lm(re78 ~ treat + age + black + I(black*age), data = obs.lalonde)
lm(re78 ~ ., data = obs.lalonde)

86/880 # aggregate purchase rate for members
124/1260 # aggregate purchase rate for non-members

22/484 # members, 31-40
22/504 # non-members, 31-40

30/308 
43/567

34/88
59/189
