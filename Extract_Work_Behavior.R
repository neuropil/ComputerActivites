test <- read.csv('work_applications_07202013.csv')
head(test)
out = order(test$Process)
test2 = test[out,]
