library(foreign)

data <- read.dta('12.2 jtpa.dta')
head(data)

which.tr.assgn <- which(data$assignmt == 1)
data.trt <- data[which.tr.assgn, ]
data.ctr <- data[-which.tr.assgn, ]

mean(data.trt$age) - mean(data.ctr$age)
mean(data.trt$married) - mean(data.ctr$married)

sum(data$assignmt == data$training & data$assignmt == 1) / length(data$assignmt)
