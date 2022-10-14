#Data Cleaning
library(rstudioapi)
library()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

DF <- read.csv("1000RKInfoBangumi_cleaned.txt",header=TRUE,encoding='UTF-8')
#head(DF)

DF <- DF[c('Tags','Score')]
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
  templist=strsplit(DF[i,'Tags'],',')
  for(word in templist){
    #word <- iconv(word, to = 'UTF-8')
    wordtable <- rbind(wordtable, data.frame(Word=word,Score=DF[i,'Score']))
  }
}

#head(wordtable)
target = tapply(wordtable$Score,INDEX=wordtable$Word, FUN=sum)

#DF[800,'Score']

target <- sort(target, decreasing = TRUE)
#dim(target)
#target
new_DF = data.frame(Word=names(target),total_score=target)
rownames(new_DF) <- 1:nrow(target)
new_DF[1:50,]
#write.table(new_DF,file="Bangu_RK_cut_tail_score.txt",'sep'=',',row.names=FALSE)
write.csv(new_DF,file="Bangu_RK_whole_score.txt",row.names=FALSE,encoding='UTF-8')
wordcloud2(new_DF,fontFamily = '微软雅黑',shape='star')
