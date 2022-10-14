#Data Cleaning
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

DF <- read.csv("1000RKInfo_cleaned.txt",header=TRUE)
#head(DF)

DF <- DF[c('Genres','Score')]
#head(DF)

DF$Score <- as.numeric(DF[,'Score'])
DF <- DF[!is.na(DF['Score']),]
#cat(min(DF['Score']))

#DF$Score <- DF$Score - min(DF['Score'])
#head(DF)

#cat(dim(DF))
rownames(DF) <- 1:nrow(DF)

wordtable=as.data.frame(matrix(nrow=0,ncol=2))
colnames(wordtable) <- c('Word','Score')

for(i in 1:nrow(DF)){
  templist=strsplit(DF[i,'Genres'],',')
  for(word in templist){
    wordtable <- rbind(wordtable, data.frame(Word=word,Score=DF[i,'Score']))
  }
}

target = tapply(wordtable$Score,INDEX=wordtable$Word, FUN=sum)

#DF[800,'Score']

target <- sort(target, decreasing = TRUE)
#dim(target)
#target
new_DF = data.frame(Word=names(target),total_score=target)
rownames(new_DF) <- 1:nrow(target)

#write.table(new_DF,file="RK_cut_tail_score.txt",'sep'=',',row.names=FALSE)
write.table(new_DF,file="RK_whole_score.txt",'sep'=',',row.names=FALSE)