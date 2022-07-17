## Breast Cancer Prediction
### Setup & Installation
Make sure you have the latest version of [R](https://www.r-project.org/) installed.

Recommend IED: [RStudio](https://www.rstudio.com/products/rstudio/download/)

Install Packages
```
install.packages("tidyverse")
install.packages("caret")
install.packages("boot")
install.packages("forecast")
install.packages("StepReg")
install.packages("neuralnet")
install.packages("NeuralNetTools")
install.packages("nnet")
```
### Overview
Breast cancer is one of the most common cancers among women worldwide and leading causes of cancer death in the United States. Breast tumors can be seen via X-ray or felt as lumps in breast area by self-examanation. When a suspicious lump is detected, the doctor will conduct a diagnosis to determine whether it is malignant (cancerous) or begnin(non-cancerous). 

In this project, the dataset was obtained from the University of Wisconsin Hospitals, Madison. Features (Predictors/ Variable) in the dataset are computed from a digitized image of a fine needle aspirate (FNA) of a breast mass, describing characteristics of the cell nuclei present in the image. The goal of this project is to classify each breast mass into malignant or benign using machine learning, trying to find out what features significantly impact the result of target variable in the prediction. 
### Machine Learning
* Logistic Regression Model with Principal Components
  Used Principal Components Analysis to find and remove the overlap of information between predictors. 
  Created small subset of predictors that contain most of the information and replaced origial predictors with the subset. 
  Applied Logistic Regression Model to the subset
  Used K-Fold Cross Validation to examine overfitting issue
* Logistic Regression Model with Origial Predictors
  Ran Stepwise Regression to drop predictors and get optimal models
  Trained Logistic Regression Model
*  k-nearest neighbors (KNN)
*  Neural Network
### Summary
Logistic Regression Model with Principal Components gives the hiest accuracy of prediction among these four models.
```
Confusion Matrix and Statistics

          Reference
Prediction   1   0
         1 208   1
         0   4 356
                                          
               Accuracy : 0.9912          
                 95% CI : (0.9796, 0.9971)
    No Information Rate : 0.6274          
    P-Value [Acc > NIR] : <2e-16  
```
I found that the following glm formula would provide highest accuracy among others
```
glm(formula = diagnosis ~ concave.points_worst + radius_worst + 
    radius_se + texture_worst, family = "binomial", data = train.df)
```
```
Confusion Matrix and Statistics

          Reference
Prediction   1   0
         1  90   3
         0   5 130
                                         
               Accuracy : 0.9649         
                 95% CI : (0.932, 0.9847)
    No Information Rate : 0.5833         
    P-Value [Acc > NIR] : <2e-16
```
Mean of the three largest values in severity of concave portions of the contour, stardard error and mean of the three largest values of radius, and Mean of the three largest values in standard deviation of gray-scale values has significan impact on the diagnosis of breast mass. The higher value they are, the higher probability that the breast mass is malignant.   

```
Coefficients:
                     Estimate Std. Error z value Pr(>|z|)    
(Intercept)          -39.9576     8.4876  -4.708 2.50e-06 ***
concave.points_worst  66.5244    16.3767   4.062 4.86e-05 ***
radius_worst           1.1373     0.2896   3.928 8.58e-05 ***
radius_se             11.7350     3.1175   3.764 0.000167 ***
texture_worst          0.3303     0.0959   3.445 0.000572 ***
```
### About Dataset
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
The mean, standard error, and worst (mean of the three largest values) of these features were computed for each breast tissue image. 
* Mean of Radius -> radius_mean
* Standard Error of Radius -> radius_se
* Worst Radius of Radius   -> radius_worst
### Sources
This breast cancer dataset on [Kaggle](https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data) was obtained from the [University of Wisconsin Hospitals, Madison from Dr. William H. Wolberg](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29)

