### SVM-RFE using R ###

## install Packages
library(tidyverse)
library(GGally)
library(dplyr)
library(Boruta)
library(Metrics)
library(caret)
library(randomForest)
library(InformationValue)
library(MASS)
library(e1071)
library(nnet)
library(caret)
library(mlbench)
library(kernlab)

## Parallel Processing
library(doParallel)
cl <- makePSOCKcluster(8)
registerDoParallel(cl)

library(doMC)
registerDoMC(cores = 2)

## Data
data <- read.csv("TCGA_T_RFE.csv", header = TRUE)

## Subsets if We want
subsets <- c(1:10)

## Control parameters
control <- rfeControl(functions=caretFuncs, 
                   method = "repeatedcv",
                   repeats =5, number = 10,
                   returnResamp="final", verbose = TRUE)
                   
 trainctrl <- trainControl(classProbs = TRUE,
                          summaryFunction = twoClassSummary)
                          
 ## Class probes as factors
 data$diagnosis <- factor(data$diagnosis)
 
 rfe <- rfe(data[, 2:length(data)],         
                 data[, 1],                   
                 sizes = 2:(length(data)-1),  
                 rfeControl = control,
                 method = "svmRadial",
                 metric = "ROC",
                 trControl = trainctrl)

## stop the cluster ##
stopCluster(cl)



