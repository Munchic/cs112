### GENERATING DATA

amt_food = runif(200, max = 800, min = 230)
amt_liquid = abs(rnorm(200, 200, 50))
avg_scoville = abs(rnorm(200, 2000, 2000))
p_win = 1 / (1 + exp(-(sqrt(amt_food) * log(avg_scoville) - pi * amt_liquid + rnorm(1, 100, 50))))

spicy_minerva = data.frame(amt_food,
                           amt_liquid,
                           avg_scoville,
                           p_win)

colnames(spicy_minerva) <- c("Amount of food (g)",
                             "Amount of liquid (ml)",
                             "Average spiciness (scov)",
                             "Chance to win")

### SPLITTING DATA INTO TRAIN AND TEST SETS

train_idx <- sample(nrow(spicy_minerva) / 2)
spicy_minerva_train <- spicy_minerva[train_idx,]
spicy_minerva_test <- spicy_minerva[-train_idx,]
write.csv(spicy_minerva_train, file = "spicy_minerva_train.csv")
write.csv(spicy_minerva_test, file = "spicy_minerva_test.csv")

### TASK 2: TRAINING SET RMSE

df = read.csv("income_level_train.csv")
head(df)

model <- lm(df$Monthly.Income.... ~ df$Age + df$IQ.Level)
rmse = mean(model$residuals)
print(rmse)

### TASK 3: TEST SET RMSE

spic = read.csv("spicy_minerva_test.csv")
head(spic)

model <- lm(spic$Chance.to.win ~ spic$Amount.of.liquid..ml.)
rmse = mean(model$residuals)
print(rmse)

amt_food = spic$Amount.of.food..g.
avg_scoville = spic$Average.spiciness..scov.
amt_liquid = spic$Amount.of.liquid..ml.

p_win = 1 / (1 + exp(-(sqrt(amt_food) * log(avg_scoville) - pi * amt_liquid)))

# RMSE
sqrt(mean((p_win - spic$Chance.to.win)^2))

# R^2 = 1 - S(res) / S(tot)
1 - (p_win - spic$Chance.to.win)^2 / (spic$Chance.to.win - mean(spic$Chance.to.win)^2)
