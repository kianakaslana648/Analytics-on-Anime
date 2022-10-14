library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(rpart)
library(rattle)
library(rpart.plot)

library(rsample)
library(readr)

RecordDF <- read_csv("Pokemon.csv",col_names=TRUE)

RecordDF=as.data.frame(RecordDF)
RecordDF<-subset(RecordDF, select=-c(1,2,4))

colnames(RecordDF)[1]='class'
table(RecordDF$class)

#Code
set.seed(123)
split_strat <- initial_split(RecordDF, prop = 0.8,
                             strata = 'class')
RecordDF_Train <- training(split_strat)
RecordDF_Test <- testing(split_strat)

(RecordDF_TestLabels<-RecordDF_Test$class )

RecordDF_Test<-subset( RecordDF_Test, select = -c(class))

colnames(RecordDF_Train)

fitR_g1 <- rpart(RecordDF_Train$class~., data = RecordDF_Train, method="class"
                ,parms=list(split = "gini"),control = rpart.control(cp = 0.01))
fitR_g2 <- rpart(RecordDF_Train$class~., data = RecordDF_Train, method="class"
                 ,parms=list(split = "gini"),control = rpart.control(cp = 0.001))
fitR_e1 <- rpart(RecordDF_Train$class~., data = RecordDF_Train, method="class"
                ,parms=list(split = "entropy"),control = rpart.control(cp = 0.01))
fitR_e2 <- rpart(RecordDF_Train$class~., data = RecordDF_Train, method="class"
                 ,parms=list(split = "entropy"),control = rpart.control(cp = 0.001))

predictedR_g1 = predict(fitR_g1,RecordDF_Test, type="class")
predictedR_g2 = predict(fitR_g2,RecordDF_Test, type="class")
predictedR_e1 = predict(fitR_e1,RecordDF_Test, type="class")
predictedR_e2 = predict(fitR_e2,RecordDF_Test, type="class")

## Confusion Matrix
conf_matrix_g1=table(predictedR_g1,RecordDF_TestLabels)
conf_matrix_g1
conf_matrix_g2=table(predictedR_g2,RecordDF_TestLabels)
conf_matrix_g2
conf_matrix_e1=table(predictedR_e1,RecordDF_TestLabels)
conf_matrix_e1
conf_matrix_e2=table(predictedR_e2,RecordDF_TestLabels)
conf_matrix_e2

sum(diag(conf_matrix_g1))/length(predictedR)
diag(conf_matrix_g1)/colSums(conf_matrix_g1)

sum(diag(conf_matrix_g2))/length(predictedR)
diag(conf_matrix_g2)/colSums(conf_matrix_g2)

sum(diag(conf_matrix_e1))/length(predictedR)
diag(conf_matrix_e1)/colSums(conf_matrix_e1)

sum(diag(conf_matrix_e2))/length(predictedR)
diag(conf_matrix_e2)/colSums(conf_matrix_e2)

## VIS..................
fancyRpartPlot(fitR_g1,tweak=1.2)

fancyRpartPlot(fitR_g2,tweak=1.2)

fancyRpartPlot(fitR_e1,tweak=1.2)

fancyRpartPlot(fitR_e2,tweak=1.2)
