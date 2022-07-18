# load data
breast.df <- read.csv('https://raw.githubusercontent.com/rosylin0812/Breast-Cancer-Prediction/main/Breast%20Cancer%20Data.csv')
# drop ID column
breast.df <- breast.df[-1]

library(tidyverse)
library(repr)

# overview of data
breast.df %>% 
  gather(var, value) %>% 
  distinct() %>% 
  count(var)

# Getting the Unique Values present in every column
unique_values <- lapply(breast.df, unique)
#View(unique_values)


# Replace values
# M = malignant, B = benign >>>  1= malignant, 0 = benign
col = ncol(breast.df)
row = nrow(breast.df)
for (a in 1:row){
  breast.df[a,1] = if (breast.df[a,1] == "M"){breast.df[a,1] = 1}else{breast.df[a,1] = 0}
}
breast.df$diagnosis <- as.numeric(breast.df$diagnosis)


cov(na.omit(breast.df))
cor(na.omit(breast.df))

##############  Regression with Principle Components ###################
### Whole dataset as validation dataset ###
### PCA on all 31 variables WITH normalization ###
pcs.cor <- prcomp(na.omit(breast.df), scale. = T) # scale. = T is for normalization
summary(pcs.cor) 

# plot distribution of priciple components
PoV.cor <- pcs.cor$sdev^2 / sum(pcs.cor$sdev^2)
barplot(PoV.cor, xlab = "Principal Components", ylab = "Proportion of Variance Explained",ylim=c(0,0.3))

# take first 6 variables from PCA because PC6 the cumulative proportion is greater than 0.90
pcs.data<-data.frame(pcs.cor$x[,1:6], breast.df$diagnosis) 

pcs.data

# logistic regression
reg <- glm(breast.df.diagnosis ~ .,data=pcs.data, family="binomial")
summary(reg)
reg.pred <- predict(reg, pcs.data, type='response')
reg.pred.class <- factor(ifelse(reg.pred > 0.5, 1, 0), levels=c('1', '0'))
library(caret)
confusionMatrix(reg.pred.class, factor(breast.df$diagnosis, levels=c('1', '0')), positive='1')


###### k fold cross validation
library(boot)
cv.glm(data= pcs.data, glmfit=reg, K =10)
#The first component of delta is the average mean-squared error from doing K-fold CV.

#The second component of delta is the just the first component of delta with a bias correction. 



############################# split the dataset #############################

# Training / Test datasets
set.seed(1) 
train.index <- sample(c(1:dim(breast.df)[1]), 0.6*nrow(breast.df[1]))
train.df <- breast.df[train.index,]
valid.df <- breast.df[-train.index,]

##############  Regression without Principle Components ###################

###### stepwise selection
#bidirection
library(StepReg)
formula = diagnosis ~ .
cancer.glm.step <- stepwiseLogit(formula, data = train.df,  include = NULL, 
                                 selection = "bidirection",
                                 select="SL",
                                 sle=0.0001,
                                 sls=0.0001,
                                 sigMethod="Rao")
cancer.glm.step  # Which variables did it drop?

#Try different formula from the results of stepwise selection
reg <- glm(diagnosis ~ .,data=train.df, family="binomial")

reg <- glm(diagnosis ~ perimeter_worst+ concave.points_worst+ texture_mean+ 
             radius_se+ compactness_se,data=train.df, family="binomial")

reg <- glm(diagnosis ~ perimeter_worst+ concave.points_worst+ texture_mean+ 
             radius_se+ compactness_se+ symmetry_worst,data=train.df, family="binomial")

reg <- glm(diagnosis ~ perimeter_worst+ concave.points_worst+ texture_mean+ 
             radius_se+ compactness_se+ symmetry_worst+ smoothness_se+
             concavity_mean,data=train.df, family="binomial")

reg <- glm(diagnosis ~ concave.points_worst+ radius_worst+ 
             radius_se+ texture_worst,data=train.df, family="binomial")

reg <- glm(diagnosis ~ concave.points_worst+ radius_worst+ 
             texture_worst,data=train.df, family="binomial")   
summary(reg) 

###### k fold cross validation
library(boot)
cv.glm(data= train.df, glmfit=reg, K =10)

###### regression without PCA perform?
reg.pred <- predict(reg, valid.df, type='response')
reg.pred.class <- factor(ifelse(reg.pred > 0.6, 1, 0), levels=c('1', '0'))
confusionMatrix(reg.pred.class, factor(valid.df$diagnosis, levels=c('1', '0')), positive='1')


##############  K-Neareast     #################
library(class)
library(caret)

#Find optimal K (from 1 to 15)
train.diagnosis <- as.factor(train.df$diagnosis)
valid.diagnosis <- as.factor(valid.df$diagnosis)

accuracy.df <- data.frame(k = seq(1, 15, 1), accuracy = 0)
#View(accuracy.df)
for(i in 1:15) {
  knn.pred <- knn(train.df, valid.df, cl=train.diagnosis, k=i)
  accuracy.df[i, 'accuracy'] <- confusionMatrix(knn.pred, valid.diagnosis)$overall[1] 
}
accuracy.df

# run kNN with k=5
nn5 <- knn(train.df, valid.df, cl=as.factor(train.df$diagnosis), k=5)
# kNN performance
confusionMatrix(as.factor(nn5), as.factor(valid.df$diagnosis))


##############  Neural Network #################

#install.packages("neuralnet")
#install.packages("NeuralNetTools")
library(neuralnet)
library(NeuralNetTools)
library(nnet)
library(caret)
install.packages("nnet")
# run neural network
nn <- neuralnet(diagnosis ~ ., 
                data=train.df, hidden=c(2,3,4),learningrate=0.01,stepmax=1e6)# highest

# neural network results
plotnet(nn)
neuralweights(nn)

# neural network performance
nn.pred <- compute(nn, valid.df)
nn.class <- ifelse(nn.pred$net.result > 0.5, 1, 0)
#nn.class
confusionMatrix(as.factor(nn.class), as.factor(valid.df$diagnosis))

##############  Random Forest #################
library(randomForest)
rf <- randomForest(as.factor(diagnosis) ~ ., data = train.df, ntree = 500, 
                   mtry = 4, nodesize = 5, importance = TRUE)  

## variable importance plot
varImpPlot(rf, type = 1)
summary(rf)
#votes: a matrix with one row for each input data point and one column for each class
rf$votes

## Prediction & Evaluation
rf.pred <- predict(rf, valid.df)
library(caret)
confusionMatrix(as.factor(rf.pred), as.factor(valid.df$diagnosis))
