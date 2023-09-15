# Real-Estate-Price-Prediction-Using-R

**Overview**
In the real estate industry, pricing plays a pivotal role in attracting buyers and ensuring consistent revenue for property developers. I have made an attempt to create a robust predictive model for property prices. The model utilizes machine learning techniques to analyze various property features and determine their impact on the final price.

criteria was - score > 0.51
calculated as - 212467/RMSE

**Data**
housing_train.csv: This dataset contains the training data with various features, including the response variable "Price."
housing_test.csv: This dataset contains the test data with the same features as the training data, except for the "Price" column, which needs to be predicted.

**Model Development**
**Regression Tree (Initial Attempt)** 
the initial attempt yielded a relatively low predictive accuracy with a score of 0.26.

**Linear Regression (Improved Model)**
Recognizing the need for better performance, the project transitioned to linear regression. Linear regression is a powerful tool for modeling the relationship between independent variables (features) and a continuous dependent variable (price). the final linear regression model achieved a significant improvement in predictive accuracy, with a score of 0.54.

**Usage**
Data Preparation: Ensure that you have both housing_train.csv and housing_test.csv datasets available.
Code: You can find the code used to develop the regression and classification tree models in this project's repository.
Predictions: Predictions for the housing_test.csv dataset using the classification tree model have been stored in a CSV file named **Punit_Alkunte_P1_P2.csv**.

**Conclusion**
My analysis reveals that a linear regression model with score of 0.54 provides valuable insights into predicting property prices and can be used to predict prices for properties with various factors given.

**Thankyou**
