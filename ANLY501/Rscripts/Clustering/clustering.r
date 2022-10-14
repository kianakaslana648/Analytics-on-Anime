library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(readr)
DF <- read_csv("animeReviewsOrderByTime.txt",col_names=TRUE)

DF=as.data.frame(DF)
DF<-subset(DF,select=-c(id,workId,reviewId,postTime,author,review))

DF[DF$episodesSeen=='\\N','episodesSeen']=0

DF$episodesSeen<-as.numeric(DF$episodesSeen)

quan1=quantile(DF$peopleFoundUseful,0.9)
quan2=quantile(DF$episodesSeen,0.9)

DF$peopleFoundUseful<-lapply(DF$peopleFoundUseful,function(x) 
  10*min(x[1],quan1)/quan1)
DF$episodesSeen<-lapply(DF$episodesSeen,function(x) 
  10*min(x[1],quan2)/quan2)
DF$peopleFoundUseful=unlist(DF$peopleFoundUseful)
DF$episodesSeen=unlist(DF$episodesSeen)

library(cluster)
library(ggplot2)
library(factoextra)

###DF with all attributes
#####K-means
MyDF_test=DF[1:1000,]
MyDF_test=subset(MyDF_test,select=-workName)
MyDF_test[1:20,]
fviz_nbclust(MyDF_test, kmeans, method='wss',k.max=10)+
  geom_vline(xintercept = 2, linetype = 2)
fviz_nbclust(MyDF_test, kmeans, method='silhouette',k.max=10)+
  geom_vline(xintercept = 3, linetype = 2)
fviz_nbclust(MyDF_test, kmeans, method='gap_stat',k.max=10)+
  geom_vline(xintercept = 5, linetype = 2)

MyDF=subset(DF,select=-workName)

DF_km=kmeans(MyDF,2)

fviz_cluster(DF_km, data = MyDF,ellipse.type = "convex",
             axes = c(1, 2),
             geom='point',
             pointsize = 0.08)

DF_km=kmeans(MyDF,3)

fviz_cluster(DF_km, data = MyDF,ellipse.type = "convex",
             axes = c(1, 2),
             geom='point',
             pointsize = 0.08)

DF_km=kmeans(MyDF,4)

fviz_cluster(DF_km, data = MyDF,ellipse.type = "convex",
             axes = c(1, 2),
             geom='point',
             pointsize = 0.08)

DF_km=kmeans(MyDF,5)

fviz_cluster(DF_km, data = MyDF,ellipse.type = "convex",
             axes = c(1, 2),
             geom='point',
             pointsize = 0.08)
###DF with ratings only
R_DF=subset(MyDF,select=-c(peopleFoundUseful,episodesSeen,overallRating))
R_DF_test=R_DF[1:1000,]
fviz_nbclust(R_DF_test, kmeans, method='silhouette',k.max=10)+
  geom_vline(xintercept = 2, linetype = 2)

R_DF_km=kmeans(R_DF,2)

fviz_cluster(R_DF_km, data = R_DF,ellipse.type = "convex",
             geom='point',
             pointsize = 0.08,
             axes=c(1,2))

###DF on SAO
SAO_DF=DF[DF$workName=='Sword_Art_Online',]
SAO_DF=subset(SAO_DF,select=-workName)
fviz_nbclust(SAO_DF, kmeans, method='wss',k.max=10)+
  geom_vline(xintercept = 2, linetype = 2)
fviz_nbclust(SAO_DF, kmeans, method='silhouette',k.max=10)+
  geom_vline(xintercept = 2, linetype = 2)
fviz_nbclust(SAO_DF, kmeans, method='gap_stat',k.max=10)+
  geom_vline(xintercept = 2, linetype = 2)

SAO_DF_km=kmeans(SAO_DF,2)

fviz_cluster(SAO_DF_km, data = SAO_DF,ellipse.type = "convex",
             geom='point',
             pointsize = 1,
             axes=c(1,2))

#####Hclust
library(slam)
(d_E <- dist(SAO_DF,method="euclidean"))
(d_Man <- dist(SAO_DF,method="manhattan"))


Matrix <- as.matrix(SAO_DF)
sim <- Matrix / sqrt(rowSums(Matrix * Matrix))
sim <- sim %*% t(sim)
D_Cos <- as.dist(1 - sim)

fviz_nbclust(SAO_DF, method = "silhouette", FUN = hcut, k.max = 4)

fit_E <- hclust(d_E, method="ward.D2")
plot(fit_E)
labels1=cutree(fit_E,k=3)
fviz_cluster(object=list(data=SAO_DF,cluster=labels1), data = SAO_DF,
             ellipse.type = "convex",
             geom='point',
             pointsize = 1,
             axes=c(1,2))

fit_Man <- hclust(d_Man, method="ward.D2")
plot(fit_Man)
labels2=cutree(fit_Man,k=3)
fviz_cluster(object=list(data=SAO_DF,cluster=labels2), data = SAO_DF,
             ellipse.type = "convex",
             geom='point',
             pointsize = 1,
             axes=c(1,2))

fit_Cos <- hclust(d_Cos, method="ward.D2")
plot(fit_Cos)
labels2=cutree(fit_Cos,k=3)
fviz_cluster(object=list(data=SAO_DF,cluster=labels2), data = SAO_DF,
             ellipse.type = "convex",
             geom='point',
             pointsize = 1,
             axes=c(1,2))
