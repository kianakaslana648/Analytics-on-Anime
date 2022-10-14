library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(Rspotify)
library(httr)
library(jsonlite)
library(spotifyr)

library(naivebayes)
#Loading required packages
#install.packages('tidyverse')
library(tidyverse)
#install.packages('ggplot2')
library(ggplot2)
#install.packages('caret')
library(caret)
#install.packages('caretEnsemble')
library(caretEnsemble)
#install.packages('psych')
library(psych)
#install.packages('Amelia')
library(Amelia)
#install.packages('mice')
library(mice)
#install.packages('GGally')
library(GGally)
library(e1071)
library(mlr)
library(party)
library(permimp)

my_token=get_spotify_access_token(client_id='1f705b5dfc83489ab49b857780010015',
                         client_secret='710066e4c9004b43b3c8df3a2caac6ad'
                         )

SPOTIFY_CLIENT_ID='1f705b5dfc83489ab49b857780010015'
SPOTIFY_CLIENT_SECRET='710066e4c9004b43b3c8df3a2caac6ad'

Sys.setenv(SPOTIFY_CLIENT_ID = SPOTIFY_CLIENT_ID)
Sys.setenv(SPOTIFY_CLIENT_SECRET = SPOTIFY_CLIENT_SECRET)

access_token<-get_spotify_access_token()

Radwimps<-get_artist_audio_features('Radwimps')
Kana_Hanazawa<-get_artist_audio_features('Kana Hanazawa')
Amamiya_Sora<-get_artist_audio_features('Amamiya Sora')
ZARD<-get_artist_audio_features('ZARD')
Ito_kanako<-get_artist_audio_features('Ito_kanako')


colnames(Radwimps)

Radwimps_A<-subset(Radwimps,select=c(artist_name,valence,danceability,
                                     energy,loudness,speechiness,
                                     acousticness,liveness,
                                     tempo,mode_name))

Kana_Hanazawa_A<-subset(Kana_Hanazawa,select=c(artist_name,valence,danceability,
                                     energy,loudness,speechiness,
                                     acousticness,liveness,
                                     tempo,mode_name))

Amamiya_Sora_A<-subset(Amamiya_Sora,select=c(artist_name,valence,danceability,
                                             energy,loudness,speechiness,
                                             acousticness,liveness,
                                             tempo,mode_name))

ZARD_A<-subset(ZARD,select=c(artist_name,valence,danceability,
                                             energy,loudness,speechiness,
                                             acousticness,liveness,
                                             tempo,mode_name))

Ito_kanako_A<-subset(Ito_kanako,select=c(artist_name,valence,danceability,
                             energy,loudness,speechiness,
                             acousticness,liveness,
                             tempo,mode_name))

df<-rbind(Radwimps_A,Kana_Hanazawa_A)
df<-rbind(df,Amamiya_Sora_A)
df<-rbind(df,ZARD_A)
df<-rbind(df,Ito_kanako_A)
  
dim(df)

write.csv(df,'animeMusic.csv',row.names=FALSE)

df<-read.csv('animeMusic.csv')

df=subset(df,select=-c(mode_name))

df$artist_name<-as.factor(df$artist_name)

(Size <- (as.integer(nrow(df)/4)))
(SAMPLE <- sample(nrow(df), Size, replace = FALSE))

(df_test<-df[SAMPLE, ])
(df_train<-df[-SAMPLE, ])

(df_test_labels <- df_test$artist_name)
(df_train_labels <- df_train$artist_name)

df_test_NL<-df_test[ , -which(names(df_test) %in% c("artist_name"))]
df_train_NL<-df_train[ , -which(names(df_train) %in% c("artist_name"))]

x <- df_train_NL 
y <- df_train_labels

model1 = caret::train(x,y,'nb', 
                     trControl=trainControl(method='cv'
                                                      ,number=10
                                                      ,repeats=3))
model2 = caret::train(x,y,'nb', 
                     trControl=trainControl(method='boot'
                                            ,number=10
                                            ,repeats=3))

model3 = caret::train(x,y,'nb', 
                     trControl=trainControl(method='repeatedcv'
                                            ,number=10
                                            ,repeats=3))

Predict1 <- predict(model1,df_test_NL)
plot(Predict1)
Predict2 <- predict(model2,df_test_NL)
plot(Predict2)
Predict3 <- predict(model3,df_test_NL)
plot(Predict3)

result1=data.frame(table(Predict1))
result2=data.frame(table(Predict2))
result3=data.frame(table(Predict3))

ggplot(data=result1,aes(x='',y=Freq,fill=Predict1))+
  geom_bar(stat='identity')+coord_polar(theta='y')
ggplot(data=result2,aes(x='',y=Freq,fill=Predict2))+
  geom_bar(stat='identity')+coord_polar(theta='y')
ggplot(data=result3,aes(x='',y=Freq,fill=Predict3))+
  geom_bar(stat='identity')+coord_polar(theta='y')

cm=table(Predict1,df_test_labels)
cm
diag(t(cm)/colSums(cm))
#Plot Variable performance
X <- varImp(model1)
plot(X)


total_imp<-data.frame(names=colnames(df_train_NL),
                      imp=rowSums(X$importance))
ggplot(data=total_imp, aes(x=names,y=imp))+geom_bar(stat='identity')


svm_model1<-svm(artist_name~.,data=df_train,kernel='polynomial'
    ,cost=100,scale=FALSE)
svm_model2<-svm(artist_name~.,data=df_train,kernel='radial'
                ,cost=1000,scale=FALSE)
svm_model3<-svm(artist_name~.,data=df_train,kernel='sigmoid'
                ,cost=1,scale=FALSE)


pred1 <- predict(svm_model1, df_test_NL)
cor1 <- table(pred1,df_test_labels)
cor1
diag(t(cor1)/colSums(cor1))

pred2 <- predict(svm_model2, df_test_NL)
cor2 <- table(pred2,df_test_labels)
cor2
diag(t(cor2)/colSums(cor2))

pred3 <- predict(svm_model3, df_test_NL)
cor3 <- table(pred3,df_test_labels)
cor3
diag(t(cor3)/colSums(cor3))

svm_model_P1<-svm(artist_name~.,data=df_train,kernel='polynomial'
                ,cost=0.1,scale=FALSE,degree=1)
svm_model_P2<-svm(artist_name~.,data=df_train,kernel='polynomial'
                  ,cost=1000,scale=FALSE,degree=2)
svm_model_P3<-svm(artist_name~.,data=df_train,kernel='polynomial'
                  ,cost=0.1,scale=FALSE,degree=3)
svm_model_P4<-svm(artist_name~.,data=df_train,kernel='polynomial'
                  ,cost=10000,scale=FALSE,degree=4)



pred_P1 <- predict(svm_model_P1, df_test_NL)
cor_P1 <- table(pred_P1,df_test_labels)
cor_P1
diag(t(cor_P1)/colSums(cor_P1))

pred_P2 <- predict(svm_model_P2, df_test_NL)
cor_P2 <- table(pred_P2,df_test_labels)
cor_P2
diag(t(cor_P2)/colSums(cor_P2))

pred_P3 <- predict(svm_model_P3, df_test_NL)
cor_P3 <- table(pred_P3,df_test_labels)
cor_P3
diag(t(cor_P3)/colSums(cor_P3))

pred_P4 <- predict(svm_model_P4, df_test_NL)
cor_P4 <- table(pred_P4,df_test_labels)
cor_P4
diag(t(cor_P4)/colSums(cor_P4))

tuned_cost <- tune(svm,artist_name~.,data=df_train,kernel='polynomial',
                   degree=2,
                   ranges=list(cost=c(1,10,100,1000,10000,100000
                                      )))
summary(tuned_cost)

