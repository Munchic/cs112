df = read.csv("income_level_train.csv")
head(df)

model <- lm(df$Monthly.Income.... ~ df$Age + df$IQ.Level)
rmse = mean(model$residuals)
print(rmse)

test_data = read.csv("income_level_test.csv")
sqrt(mean((predict(model, test_data) - df$IQ.Level)^2))
