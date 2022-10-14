#Data Cleaning
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

DF <- read.csv("1000PopInfo_cleaned.txt",header=TRUE)
#head(DF)

DF <- DF[c('Genres','Members')]
#head(DF)

DF$Members <- as.numeric(DF[,'Members'])
DF <- DF[!is.na(DF['Members']),]
#cat(min(DF['Members']))

#DF$Members <- DF$Members - min(DF['Members'])
#head(DF)

#cat(dim(DF))
rownames(DF) <- 1:nrow(DF)

wordtable=as.data.frame(matrix(nrow=0,ncol=2))
colnames(wordtable) <- c('Word','Members')

for(i in 1:nrow(DF)){
  templist=strsplit(DF[i,'Genres'],',')
  for(word in templist){
    wordtable <- rbind(wordtable, data.frame(Word=c(word),Members=c(DF[i,'Members'])))
  }
}

#table(wordtable['Word'])

target = tapply(wordtable$Members,INDEX=wordtable$Word, FUN=sum)

#DF[800,'Members']

target <- sort(target, decreasing = TRUE)
#dim(target)
#target
new_DF = data.frame(Word=names(target),total_Members=target)
rownames(new_DF) <- 1:nrow(target)

#write.table(new_DF,file="POP_cut_tail_score.txt",'sep'=',',row.names=FALSE)
write.table(new_DF,file="POP_whole_score.txt",'sep'=',',row.names=FALSE)
