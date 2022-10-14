library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(NLP)
library(tm)

TweetCorpus <- Corpus(DirSource("Tweets_cleaned"))

Tweet_dtm <- DocumentTermMatrix(TweetCorpus,
                                   control = list(
                                     stopwords = TRUE, 
                                     wordLengths=c(4, 10),
                                     removePunctuation = TRUE,
                                     removeNumbers = TRUE,
                                     tolower=TRUE,
                                     stemming = TRUE,
                                     remove_separators = TRUE,
                                     stopwords("english")
                                     )
                                   )

Tweet_DF <- as.data.frame((as.matrix(Tweet_dtm)))
Tweet_DF['Label']=c('Naruto','SteinsGate','Violet')
write.csv(Tweet_DF,file="Tweets_Dataframe",row.names=FALSE)
