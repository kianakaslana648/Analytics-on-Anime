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


##############
#TransactionTweetsFile = "tweets_Rin.csv"
#TransactionTweetsFile = "tweets_FGO.csv"
TransactionTweetsFile = "tweets_VioletEvergarden.csv"
#TransactionTweetsFile = "tweets_Gilgamesh.csv"
#TransactionTweetsFile = "tweets_SteinsGate.csv"
#TransactionTweetsFile = "tweets_AnimeFigure.csv"
#TransactionTweetsFile = "tweets_DemonSlayer.csv"
#TransactionTweetsFile = "tweets_Naruto.csv"
#TransactionTweetsFile = "tweets_Tanjirou.csv"
#TransactionTweetsFile = "TagBasket.txt"
#TransactionTweetsFile = "ReviewBasket.txt"
Lfile=paste("L_",TransactionTweetsFile)
  
TweetTrans <- read.transactions(LFile, sep =",", 
                                format("basket"),  rm.duplicates = TRUE)

############ Create the Rules  - Relationships ###########
TweetTrans_rules = arules::apriori(TweetTrans, 
                                   parameter = list(support=.06, conf=1, minlen=2))

##  SOrt by Conf
SortedRules_conf <- sort(TweetTrans_rules, by="confidence", decreasing=TRUE)
inspect(SortedRules_conf[1:20])
## Sort by Sup
SortedRules_sup <- sort(TweetTrans_rules, by="support", decreasing=TRUE)
inspect(SortedRules_sup[1:20])
## Sort by Lift
SortedRules_lift <- sort(TweetTrans_rules, by="lift", decreasing=TRUE)
inspect(SortedRules_lift[1:20])
####################################################
### HERE - you can affect which rules are used
###  - the top for conf, or sup, or lift...
####################################################
TweetTrans_rules<-SortedRules_lift
inspect(TweetTrans_rules)


## Convert the RULES to a DATAFRAME
Rules_DF2<-DATAFRAME(TweetTrans_rules, separate = TRUE)
(head(Rules_DF2))
str(Rules_DF2)
## Convert to char
Rules_DF2$LHS<-as.character(Rules_DF2$LHS)
Rules_DF2$RHS<-as.character(Rules_DF2$RHS)

## Remove all {}
Rules_DF2[] <- lapply(Rules_DF2, gsub, pattern='[{]', replacement='')
Rules_DF2[] <- lapply(Rules_DF2, gsub, pattern='[}]', replacement='')

head(Rules_DF2)

## Remove the sup, conf, and count
## USING LIFT
Rules_L<-Rules_DF2[c(1,2,5)]
names(Rules_L) <- c("SourceName", "TargetName", "Weight")
head(Rules_L,30)

## USING SUP
Rules_S<-Rules_DF2[c(1,2,3)]
names(Rules_S) <- c("SourceName", "TargetName", "Weight")
head(Rules_S,30)

## USING CONF
Rules_C<-Rules_DF2[c(1,2,4)]
names(Rules_C) <- c("SourceName", "TargetName", "Weight")
head(Rules_C,30)

## CHoose and set
#Rules_Sup<-Rules_C
Rules_Sup<-Rules_L
#Rules_Sup<-Rules_S

############################### BUILD THE NODES & EDGES ####################################
(edgeList<-Rules_Sup)
MyGraph <- igraph::simplify(igraph::graph.data.frame(edgeList, directed=TRUE))

nodeList <- data.frame(ID = c(0:(igraph::vcount(MyGraph) - 1)), 
                       # because networkD3 library requires IDs to start at 0
                       nName = igraph::V(MyGraph)$name)
## Node Degree
(nodeList <- cbind(nodeList, nodeDegree=igraph::degree(MyGraph, 
                                                       v = igraph::V(MyGraph), mode = "all")))

## Betweenness
BetweenNess <- igraph::betweenness(MyGraph, 
                                   v = igraph::V(MyGraph), 
                                   directed = TRUE) 

(nodeList <- cbind(nodeList, nodeBetweenness=BetweenNess))

## This can change the BetweenNess value if needed
#BetweenNess<-BetweenNess

###################################################################################
########## BUILD THE EDGES #####################################################
#############################################################
# Recall that ... 
# edgeList<-Rules_Sup
getNodeID <- function(x){
  which(x == igraph::V(MyGraph)$name) - 1  #IDs start at 0
}
(getNodeID("elephants")) 

edgeList <- plyr::ddply(
  Rules_Sup, .variables = c("SourceName", "TargetName" , "Weight"), 
  function (x) data.frame(SourceID = getNodeID(x$SourceName), 
                          TargetID = getNodeID(x$TargetName)))

head(edgeList)
nrow(edgeList)

########################################################################
##############  Dice Sim ################################################
###########################################################################
#Calculate Dice similarities between all pairs of nodes
#The Dice similarity coefficient of two vertices is twice 
#the number of common neighbors divided by the sum of the degrees 
#of the vertices. Method dice calculates the pairwise Dice similarities 
#for some (or all) of the vertices. 
DiceSim <- igraph::similarity.dice(MyGraph, vids = igraph::V(MyGraph), mode = "all")
head(DiceSim)

#Create  data frame that contains the Dice similarity between any two vertices
F1 <- function(x) {data.frame(diceSim = DiceSim[x$SourceID +1, x$TargetID + 1])}
#Place a new column in edgeList with the Dice Sim
head(edgeList)
edgeList <- plyr::ddply(edgeList,
                        .variables=c("SourceName", "TargetName", "Weight", 
                                     "SourceID", "TargetID"), 
                        function(x) data.frame(F1(x)))
head(edgeList)

##################################################################################
##################   color #################################################
######################################################
COLOR_P <- colorRampPalette(c("#00FF00", "#FF0000"), 
                            bias = nrow(edgeList), space = "rgb", 
                            interpolate = "linear")
COLOR_P
(colCodes <- COLOR_P(length(unique(edgeList$diceSim))))
edges_col <- sapply(edgeList$diceSim, 
                    function(x) colCodes[which(sort(unique(edgeList$diceSim)) == x)])
nrow(edges_col)

## NetworkD3 Object
#https://www.rdocumentation.org/packages/networkD3/versions/0.4/topics/forceNetwork

D3_network_Tweets <- networkD3::forceNetwork(
  Links = edgeList, # data frame that contains info about edges
  Nodes = nodeList, # data frame that contains info about nodes
  Source = "SourceID", # ID of source node 
  Target = "TargetID", # ID of target node
  Value = "Weight", # value from the edge list (data frame) that will be used to value/weight relationship amongst nodes
  NodeID = "nName", # value from the node list (data frame) that contains node description we want to use (e.g., node name)
  Nodesize = "nodeBetweenness",  # value from the node list (data frame) that contains value we want to use for a node size
  Group = "nodeDegree",  # value from the node list (data frame) that contains value we want to use for node color
  height = 700, # Size of the plot (vertical)
  width = 900,  # Size of the plot (horizontal)
  fontSize = 20, # Font size
  linkDistance = networkD3::JS("function(d) { return d.value*10; }"), # Function to determine distance between any two nodes, uses variables already defined in forceNetwork function (not variables from a data frame)
  linkWidth = networkD3::JS("function(d) { return d.value/10; }"),# Function to determine link/edge thickness, uses variables already defined in forceNetwork function (not variables from a data frame)
  opacity = 0.9, # opacity
  zoom = TRUE, # ability to zoom when click on the node
  opacityNoHover = 0.9, # opacity of labels when static
  linkColour = "red"   ###"edges_col"red"# edge colors
) 

# Plot network
#D3_network_Tweets

# Save network as html file
networkD3::saveNetwork(D3_network_Tweets, 
                       paste("NetD3_",TransactionTweetsFile,".html")
                       , selfcontained = TRUE)


###############
rules=TweetTrans_rules
plot(rules)

p <- plot(rules, engine = "plotly")
htmlwidgets::saveWidget(as_widget(p), paste("plot_scatter_",
                                            TransactionTweetsFile,".html"))

p <- plot(rules, method = "graph",  engine = "htmlwidget")
htmlwidgets::saveWidget(as_widget(p), paste("htmlwidget_",
                                            TransactionTweetsFile,".html"))

subrules <- head(sort(rules, by="lift"),10)
plot(subrules)
plot(subrules, method="graph", engine="interactive")