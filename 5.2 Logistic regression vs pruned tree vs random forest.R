################ PRELIMINARIES
library(MASS)
data(Pima.tr)
library(tree)
library(randomForest)

## STEP 1: Logistic regression ##
logistic_reg <- glm(type ~ ., data = Pima.tr, family = binomial) # basic model
predict_logistic.tr <- predict(logistic_reg, type = "response")  # predicted probabilities (TRAINING SET)

# Create a function that evaluates the misclassification rate for the TRAINING SET, for any threshold
evaluate_fn <- function(threshold = NA)
{
  predicted_outcomes <- as.numeric(predict_logistic.tr > threshold)
  table_logistic <- table(Pima.tr$type, predicted_outcomes)
  
  error_rate_logistic <- sum(table_logistic[2:3])/sum(table_logistic)
  return(error_rate_logistic)
}

# Optimize for threshold within TRAINING SET using a hill-climbing algorithm
best_threshold <- optim(0.5, evaluate_fn)$par
cat("\nThe best threshold is:", best_threshold, "\n\n")
cat("\nThe error rate at this threshold is:", evaluate_fn(best_threshold), "\n\n")

# Optimize for threshold within TRAINING SET using a genetic algorithm
install.packages("rgenoud")
library(rgenoud)
best_threshold_genetic <- genoud(fn = evaluate_fn, nvars = 1, max = FALSE)$par
cat("\nThe best (genetic algorithm-derived) threshold is:", best_threshold_genetic, "\n\n")
cat("\nThe error rate at this (genetic-derived) threshold is:", evaluate_fn(best_threshold_genetic), "\n\n")

# Best practice, before adopting this model, would be assess various models using cross-validation

# Produce predicted probabilities for the test set
predict_logistic <- predict(logistic_reg, newdata = Pima.te, type = "response")

# Convert those predicted probabilities to predicted TEST SET outcomes
predicted_logistic_outcomes <- as.numeric(predict_logistic > best_threshold)

# Measure misclassification error, in TEST SET
table(Pima.te$type, predicted_logistic_outcomes)
table_logistic <- table(Pima.te$type, predicted_logistic_outcomes)

error_rate_logistic <- sum(table_logistic[2:3])/sum(table_logistic)
cat("The misclassification error rate is:", error_rate_logistic, "\n\n")

## Basic tree ##
basic_tree <- tree(type ~., data = Pima.tr)
predict_basic_tree <- predict(basic_tree, newdata = Pima.te, type = "class")

table(Pima.te$type, predict_basic_tree)
table_basic_tree <- table(Pima.te$type, predict_basic_tree)

error_rate_basic_tree <- sum(table_basic_tree[2:3])/sum(table_basic_tree)
cat("\nThe estimated test set error rate for the basic tree (before cross-validating) is:", (error_rate_basic_tree), "\n\n")

## Pruned tree ##
set.seed(234235)
pruned_tree <- cv.tree(basic_tree,FUN=prune.misclass, K = length(Pima.tr$type)) # set K (# of folds) = n to perform LOOCV
print(pruned_tree)

pruned_tree <- prune.misclass(basic_tree, best = 9) # what turns out to be best?
predict_pruned_tree <- predict(pruned_tree, newdata = Pima.te, type = "class")

### HERE'S WHERE YOU BEGIN...

#####NEXT STEP: Come up with a table showing the pruned tree performance in the test set


## Random forest ##

#STEP 1: Run Random Forest model
library(randomForest)
pima.randfor <- randomForest(type ~ ., data = Pima.tr)

#STEP 2: Use your model to predict for the test set
pred <- predict(pima.randfor, newdata = Pima.te)

#STEP 3: Evaluate model performance in the test set
sum(pred == Pima.te$type) / length(pred)
cv.tree(pima.randfor, FUN=prune.misclass, K = length(Pima.tr$type))
