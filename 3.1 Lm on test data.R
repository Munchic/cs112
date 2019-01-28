library(arm)
df = read.csv("income_level.csv")
head(df)

model <- lm(df$Monthly.Income.... ~ df$Age + df$IQ.Level)
rmse = mean(model$residuals)
print(rmse)
