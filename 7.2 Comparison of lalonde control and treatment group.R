library(Matching)
data(lalonde)
age_treated <- lalonde$age[lalonde$treat == 1]
age_control <- lalonde$age[lalonde$treat == 0]

# FIRST
t.test(age_treated, age_control)

# SECOND
plot(density(age_treated), col = "red", lwd = 3)
lines(density(age_control), col = "blue", lwd = 3, lty = 5)

# THIRD
par(mfrow = c(2,1)) # PANEL PLOTS
hist(age_treated, col = "red", xlim = c(16, 80))
hist(age_control, col = "blue", xlim = c(16, 80))

dev.off() # removes the figure

# FOURTH
par(mfrow = c(2,3)) # MORE PANEL PLOTS
hist(age_treated, col = "red", xlim = c(16, 80), main = "AGE TREATED")
hist(lalonde$re74[lalonde$treat == 1], col = "red", xlim = c(0, max(lalonde$re74)), main = "RE74 TREATED")
hist(lalonde$re75[lalonde$treat == 1], col = "red", xlim = c(0,  max(lalonde$re75)), main = "RE75 TREATED")
hist(age_control, col = "blue", xlim = c(16, 80), main = "AGE CONTROL")
hist(lalonde$re74[lalonde$treat == 0], col = "blue", xlim = c(0,  max(lalonde$re74)), main = "RE74 CONTROL")
hist(lalonde$re75[lalonde$treat == 0], col = "blue", xlim = c(0,  max(lalonde$re75)), main = "RE75 CONTROL")

dev.off() # removes the figure

# FINALLY--A FUNCTION FROM THE MATCHING LIBRARY:
balanceUV(age_treated, age_control)
