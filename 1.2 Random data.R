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

head(spicy_minerva)
sum(spicy_minerva$`Chance to win` > 0.5)

if (FALSE) {
  "This data frame aims to evaluate the chance that a Minervan will win
  an national ghost pepper competition by evaluating three factors. These are:
    1. The amount of food consumed per day in Hyderabad
    2. The amount of liquid consumed while eating
    3. The average spiciness of the food consumed every day
  Since liquid helps a lot with dealing with spiciness, we can give a big penalty
  when a unit consumes liquid by having a big weight on it. As we eat spicy food,
  the more we eat, the higher the heat builds up, but the tongue also becomes more numb,
  thus, the spicy chance function will depend on amount of food sublinearly."
}