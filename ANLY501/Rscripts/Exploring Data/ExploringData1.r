library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(wordcloud2)

DF1 <- read.csv("RK_whole_score.txt",header=TRUE)
DF2 <- read.csv("RK_cut_tail_score.txt",header=TRUE)
DF3 <- read.csv("POP_whole_score.txt",header=TRUE)


wordcloud2(DF1,backgroundColor='yellow')
wordcloud2(DF2,backgroundColor='pink')
wordcloud2(DF3,backgroundColor='lightblue')
