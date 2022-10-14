library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

DF <- read.csv("1000RKInfo_cleaned.txt",header=FALSE)

DF <- DF['V8']

write.table(DF,file="TagBasket.txt",sep=',',row.names=FALSE,col.names=FALSE)
