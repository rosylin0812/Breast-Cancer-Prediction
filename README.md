### Breast Cancer Prediction
## Overview
Breast cancer is one of the most common cancers among women worldwide and leading causes of cancer death in the United States. Breast tumors can be seen via X-ray or felt as lumps in breast area by self-examanation. When a suspicious lump is detected, the doctor will conduct a diagnosis to determine whether it is malignant (cancerous) or begnin(non-cancerous). 

In this project, the dataset was obtained from the University of Wisconsin Hospitals, Madison. Features (Predictors/ Variable) in the dataset are computed from a digitized image of a fine needle aspirate (FNA) of a breast mass, describing characteristics of the cell nuclei present in the image. The goal of this project is to classify each breast mass into malignant or benign using machine learning, trying to find out what features significantly impact the result of target variable in the prediction. 

## Machine Learning
* Logistic Regression Model with Principal Components
1. Used Principal Components Analysis to find and remove the overlap of information between predictors. Created small subset of predictors that contain most of the information Replaced origial predictors with the subset. 
3. Applied Logistic Regression Model to the subset
4. Used K-Fold Cross Validation to examine overfitting issue
* Logistic Regression Model with Origial Predictors
1. Ran Stepwise Regression to drop predictors and get optimal models
2. Trained Logistic Regression Model
*  k-nearest neighbors (KNN)
*  Neural Network

## Setup Environment

Install Packages
```
install.packages("tidyverse")
install.packages("readxl")
install.packages("caret")
install.packages("boot")
install.packages("forecast")
install.packages("StepReg")
install.packages("neuralnet")
install.packages("NeuralNetTools")
install.packages("nnet")
```
## About Dataset
Features
* diagnosis: The diagnosis of breast tissues (1 = malignant, 0 = benign) where malignant denotes that the disease is harmful
* radius: distances from center to points on the perimeter
* texture: standard deviation of gray-scale values
* perimeter: size of the core tumor
* area: area of the core tumor
* mean_smoothness: mean of local variation in radius lengths
* compactness: perimeter^2 / area - 1.0. It's often associated with tumor invasiveness and morphology
* concavity: severity of concave portions of the contour
* concave points: number of concave portions of the contour
* fractal dimension: "coastline approximation" - 1

The mean, standard error, and "worst" or largest (mean of the three largest values) of these features were computed for each breast tissue image. 
Mean of Radius -> radius_mean

Standard Error -> radius_se

Worst Radius   -> radius_worst

## Sources
This breast cancer dataset on [Kaggle](https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data) was obtained from the [University of Wisconsin Hospitals, Madison from Dr. William H. Wolberg](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29)

