library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(ggplot2)

DF <- read.csv("1000RKInfo_cleaned.txt",header=TRUE)

names(DF)
DF <- DF[c('Time','Year')]

timecount=as.data.frame(table(DF['Time']))
nrow(timecount)
timecount<-timecount[!(timecount['Var1'] == 'Light novel'),]
timecount<-timecount[!(timecount['Var1'] == 'Manga'),]
timecount<-timecount[!(timecount['Var1'] == 'None'),]
timecount<-timecount[!(timecount['Var1'] == 'Original'),]
timecount<-timecount[!(timecount['Var1'] == '4-koma manga'),]

nrow(timecount)
rownames(timecount) <- 1:nrow(timecount)


timecount$Var1<-as.numeric(timecount[,'Var1'])

ggplot(timecount,aes(x=Var1,y=Freq))+geom_bar(stat='identity')+
  labs(x="Months Since Aired", y="Counts",title="Top Ranked Animes by Time")

yearcount=as.data.frame(table(DF['Year']))
#nrow(yearcount)
yearcount<-yearcount[!(yearcount['Var1'] == 'None'),]
yearcount$Var1<-droplevels(yearcount$Var1)
#head(yearcount)
#yearcount$Var1
yearcount$Var1<-as.numeric(as.character(yearcount[,'Var1']))

head(yearcount)
yearcount<-yearcount[(yearcount[,'Var1'] > 1900),]


ggplot(yearcount,aes(x=Var1,y=Freq))+geom_bar(stat='identity')+
  labs(x="Year", y="Counts",title="Top Ranked Animes by Year")

yy=vector()

for(i in 2000:2021){
  temp_DF <- read.csv(paste("AnimebyYear\\",i,".txt",sep=""),header=FALSE)
  yy<-append(yy,nrow(temp_DF))
}

yy_DF=data.frame(year=2000:2021,count=yy)
yy_DF
ggplot(yy_DF,aes(x=year,y=count))+geom_bar(stat='identity')+
  labs(x="Year", y="Counts",title="Numbers of Animes by Year")

rr=vector()

for(i in 1:22){
  rr <- append(rr,yearcount[yearcount['Var1']==1999+i,'Freq']/yy[i])
}
rr
rr_DF=data.frame(year=2000:2021,count=rr)
ggplot(rr_DF,aes(x=year,y=count))+geom_bar(stat='identity')+
  labs(x="Year", y="Fraction",title="Numbers of Anime Ranked Top 1000 Divided by Total Numbers by Year")
