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

## Data
data <- read.csv("TCGA_t_RFE.csv", header = TRUE, row.names = 1)

## Subsets if We want
subsets <- c(1:10)

## Control parameters
control <- rfeControl(functions=caretFuncs, 
                   method = "cv",
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
                 metric = "accuracy",
                 trControl = trainctrl)

