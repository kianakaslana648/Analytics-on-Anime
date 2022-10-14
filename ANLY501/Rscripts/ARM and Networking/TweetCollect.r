library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(rlang)
library(usethis)
library(devtools)
library(base64enc)
library(RCurl)
library(httr)
library(twitteR)

library(ROAuth)

library(networkD3)
library(arules)
library(rtweet)

library(tokenizers)
library(tidyverse)
library(plyr)
library(dplyr)
library(readr)
library(arulesViz)
library(plotly)
library(SnowballC)

(consumerKey='Zx63usfBwdyHQyPVmynldiA1k')
(consumerSecret='5Pxn2yVPlBHmoX6niFgTr2xhxPopkQj32J4V1N1abch14QfmBB')
(access_Token='1435212456566026246-PCAUkhPpZghogXT4XIcqCvZ2kUtCtO')
(access_Secret='Tcrbxjd7JsllnxPW94F78ZYdttkI2dmEmUuzAiB6hOYF5')

setup_twitter_oauth(consumerKey,consumerSecret,access_Token,access_Secret)
Search<-twitteR::searchTwitter("Tanjirou"
                               , since='2015-01-01',
                               until='2021-10-22', n=1000, lang='en')

(Search_DF <- twListToDF(Search))

#TransactionTweetsFile = "tweets_VioletEvergarden.csv"
#TransactionTweetsFile = "tweets_FGO.csv"
#TransactionTweetsFile = "tweets_Rin.csv"
#TransactionTweetsFile = "tweets_Gilgamesh.csv"
#TransactionTweetsFile = "tweets_SteinsGate.csv"
#TransactionTweetsFile = "tweets_Babylonia.csv"
#TransactionTweetsFile = "tweets_DemonSlayer.csv"
#TransactionTweetsFile = "tweets_Naruto.csv"
TransactionTweetsFile = "tweets_Tanjirou.csv"

Trans <- file(TransactionTweetsFile, open = "w")

MyDF<-NULL
MyDF2<-NULL

for(i in 1:nrow(Search_DF)){
  Tokens<-tokenize_words(Search_DF$text[i],stopwords = stopwords::stopwords("en"), 
                         lowercase = TRUE,  strip_punct = TRUE, simplify = TRUE)
  
  Tokens[Tokens == "t.co"] <- ""
  Tokens[Tokens == "rt"] <- ""
  Tokens[Tokens == "http"] <- ""
  Tokens[Tokens == "https"] <- ""
  
  Tokens[grepl("[[:digit:]]", Tokens)]<-""
  Tokens[(nchar(Tokens)<4 | nchar(Tokens)>9)]<-""
  
  #text_tokens(Tokens, stemmer = "en")
  
  cat(unlist(Tokens[Tokens !=""]), file=Trans, sep=",")
  cat('\n', file=Trans)
}
close(Trans)
