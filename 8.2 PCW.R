assignment1 <- function(sample) {
  assig        <- foo[sample(1:8),]

  treatment.group   <- assig[c(1,3,5,7),]
  control.group     <- assig[c(2,4,6,8),]
  
  return(mean(c(treatment.group[,2])) - mean(c(control.group[,2])))
}

assignment2 <- function(sample) {
  assig <- foo[sample(1:2),]
  for (i in 3:15) {
    if (i %% 2 != 0) {
      assig[i:i+1,]  <- foo[sample(i:i+1),]
    }
  }
  
  treatment.group   <- assig[c(1,3,5,7,9,11,13,15),]
  control.group     <- assig[c(2,4,6,8,10,12,14,16),]
  
  return(mean(c(treatment.group[,2])) - mean(c(control.group[,2])))
}

results1 <- iter.RI(assigment1)
results2 <- iter.RI(assigment2)

# p-value for 1
length(which(assigment1 >= observed.diffmeans)) / num_iter

# p-value for 2
length(which(assigment2 >= observed.diffmeans)) / num_iter