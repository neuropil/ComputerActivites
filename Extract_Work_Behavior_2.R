library(stringr)
library(lubridate)


fileList = dir()


dates = list()
appIndex = NULL
appCount = 1
for(fileL in seq(along = fileList)) {
  application = str_detect(fileList[fileL], 'applications')
  if(application){
    dates[appCount] = str_sub(fileList[fileL], 19, 26)
    dateConvert[appCount] = mdy(dates[[appCount]])
    appIndex[appCount] = fileL
    appCount = appCount + 1
  }
  
  
  
}

dayDFs = NULL
for(file.2load in 1:length(appIndex)){
#  dayDFs = read.csv(fileList[appIndex[file.2load]])
 print(fileList[appIndex[file.2load]]) 
  
  
  
}