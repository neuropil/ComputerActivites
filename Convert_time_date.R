library(stringr)
library(lubridate)
bob <- data.frame(lapply(data, as.character), stringsAsFactors=FALSE)
stringTest = bob$Start[1]
stringTest = str_replace_all(stringTest,"/","-")
out = as.POSIXct(strptime(stringTest, "%m-%d-%Y %H:%M:%S"))
