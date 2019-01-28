spic = read.csv("spicy_minerva.csv")
head(spic)

model <- lm(spic$Chance.to.win ~ spic$Amount.of.liquid..ml.)
rmse = mean(model$residuals)
print(rmse)

amt_food = spic$Amount.of.food..g.
avg_scoville = spic$Average.spiciness..scov.
amt_liquid = spic$Amount.of.liquid..ml.

p_win = 1 / (1 + exp(-(sqrt(amt_food) * log(avg_scoville) - pi * amt_liquid)))
sqrt(mean((p_win - spic$Chance.to.win)^2))
