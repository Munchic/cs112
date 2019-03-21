data <- read.csv("7.1 Market vendors and taxi drivers.csv")
head(data)
data

female_drivers <- sum(data$bg_gender == 0 & data$bg_boda == 1, na.rm = T)
female_drivers

male_drivers <- sum(data$bg_gender == 1 & data$bg_boda == 1, na.rm = T)
male_drivers

male_drivers / female_drivers
male_vendors / female_vendors

female_vendors <- sum(data$bg_femalevendor == 1, na.rm = T)
female_vendors

male_vendors <- sum(data$bg_malevendor == 1, na.rm = T)
male_vendors
