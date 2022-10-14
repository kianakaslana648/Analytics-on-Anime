library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(tm)
library(stringr)
names=c('TwitterNaruto.txt','TwitterSteinsGate.txt','TwitterViolet.txt')

name = names[1]

file1=file(name,'r')
file2=file(paste('Tweets_cleaned\\',name),'w')




sentence=readLines(file1,n=1)
sentence
#while(!sentence){
  resultstr=""
  strings = strsplit(sentence,split=" ")[[1]]

  for(i in 2:length(strings)){
    string = str_replace_all(strings[i],pattern="@.*",replacement=" ")
    string = str_replace_all(string,pattern="https://.*",replacement=" ")
    #string = str_replace_all(string,pattern="\\u[A-Za-z0-9]{4}",replacement=" ")
    string = str_replace_all(string,pattern="",replacement=" ")
    string = str_replace_all(string,pattern="#",replacement=" ")
    string = str_replace_all(string,pattern="\"",replacement=" ")
    
    resultstr = trimws(paste(resultstr, string, sep=" "),which="both")
  }
  resultstr
  writeLines(resultstr,file2)
  sentence=readLines(file1,n=1)
#}
