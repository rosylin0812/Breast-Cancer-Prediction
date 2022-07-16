## Introduction
The early diagnosis of BC can improve the prognosis and chance of survival significantly, 
as it can promote timely clinical treatment to patients. Further accurate classification of
benign tumors can prevent patients undergoing unnecessary treatments.

## About Data
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

