# LOADING LIBRARIES
library(tidyverse)
library(caret)
library(rpart)
library(class)
library(e1071)
library(pROC)
library(reshape2)
library(ggplot2)

# 1. DATA LOADING
demographic_data <- read.csv("State-wise Population, Decadal Population Growth rate and Population Density - 2011.csv")

# DATA PREPROCESSING
# Step 1: Remove India row
data_cleaned <- demographic_data[demographic_data$Category != "India", ]

# Step 2: Create density categories directly from the Population Density column
density_values <- as.numeric(data_cleaned$Population.Density..per.sq.km....2011)
data_cleaned$density_category <- ifelse(density_values <= 200, "Low",
                                        ifelse(density_values <= 500, "Medium", "High"))
data_cleaned$density_category <- factor(data_cleaned$density_category)

# Step 3: Convert numeric columns first
data_cleaned$Population <- as.numeric(gsub(",", "", data_cleaned$Population.2011))
data_cleaned$Growth_Rate <- as.numeric(data_cleaned$Decadal.Population.Growth.Rate...2001.2011)
data_cleaned$Population_Density <- density_values

# Step 4: Clean up column names and select relevant columns
data_cleaned <- data_cleaned[, c("Category", "India.State.Union.Territory", "Population", 
                                 "Growth_Rate", "Population_Density", "density_category")]
names(data_cleaned) <- c("Category", "State_UT", "Population", "Growth_Rate", "Population_Density", "density_category")

# Print category distribution
print("Category Distribution:")
print(table(data_cleaned$density_category))

# Step 5: Feature scaling
data_scaled <- data_cleaned
data_scaled$Population <- scale(data_scaled$Population)
data_scaled$Growth_Rate <- scale(data_scaled$Growth_Rate)
data_scaled$Population_Density <- scale(data_scaled$Population_Density)

# Step 6: Select features for modeling
model_data <- data_scaled[, c("Population", 
                              "Growth_Rate",
                              "Population_Density",
                              "density_category")]

# 2. DATA PARTITION
set.seed(123)
train_index <- createDataPartition(model_data$density_category, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

# 3. MODEL TRAINING
# Decision Tree
dt_model <- rpart(density_category ~ ., data = train_data, method = "class")

# KNN
knn_pred <- knn(train = train_data[, 1:3],
                test = test_data[, 1:3],
                cl = train_data$density_category,
                k = 3)

# Naive Bayes
nb_model <- naiveBayes(density_category ~ ., data = train_data)

# 4. MODEL EVALUATION
# Decision Tree Predictions
dt_pred <- predict(dt_model, test_data, type = "class")

# Naive Bayes Predictions
nb_pred <- predict(nb_model, test_data)

# 5. Create evaluation metrics
dt_cm <- confusionMatrix(dt_pred, test_data$density_category)
knn_cm <- confusionMatrix(knn_pred, test_data$density_category)
nb_cm <- confusionMatrix(nb_pred, test_data$density_category)

# Store accuracies
accuracies <- data.frame(
  Model = c("Decision Tree", "KNN", "Naive Bayes"),
  Accuracy = c(dt_cm$overall["Accuracy"],
               knn_cm$overall["Accuracy"],
               nb_cm$overall["Accuracy"])
)

# Print results
print("Model Accuracies:")
print(accuracies)


# Confusion Matrix Heatmap Function

# Decision Tree Confusion Matrix
dt_matrix <- as.matrix(dt_cm$table)
dt_heatmap <- melt(dt_matrix)
colnames(dt_heatmap) <- c("Predicted", "Actual", "Count")

# Plot for Decision Tree Confusion Matrix
ggplot(dt_heatmap, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Decision Tree Confusion Matrix", x = "Predicted", y = "Actual") +
  theme_minimal()

# Repeating similar steps for KNN and Naive Bayes
knn_matrix <- as.matrix(knn_cm$table)
knn_heatmap <- melt(knn_matrix)
colnames(knn_heatmap) <- c("Predicted", "Actual", "Count")

ggplot(knn_heatmap, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "green") +
  labs(title = "KNN Confusion Matrix", x = "Predicted", y = "Actual") +
  theme_minimal()

nb_matrix <- as.matrix(nb_cm$table)
nb_heatmap <- melt(nb_matrix)
colnames(nb_heatmap) <- c("Predicted", "Actual", "Count")

ggplot(nb_heatmap, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Naive Bayes Confusion Matrix", x = "Predicted", y = "Actual") +
  theme_minimal()


# Barplot for model comparison
ggplot(accuracies, aes(x = Model, y = Accuracy, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Accuracy Comparison", y = "Accuracy", x = "Model") +
  theme_minimal() +
  scale_fill_manual(values = c("blue", "green", "red"))

# Scatter plot between Population and Growth Rate
ggplot(data_cleaned, aes(x = Population, y = Growth_Rate, color = density_category)) +
  geom_point() +
  labs(title = "Population vs Growth Rate", x = "Population", y = "Growth Rate") +
  theme_minimal()

# Scatter plot between Population Density and Growth Rate
ggplot(data_cleaned, aes(x = Population_Density, y = Growth_Rate, color = density_category)) +
  geom_point() +
  labs(title = "Population Density vs Growth Rate", x = "Population Density", y = "Growth Rate") +
  theme_minimal()

# Boxplot of errors for Decision Tree
dt_errors <- test_data$density_category != dt_pred
ggplot(data.frame(Error = dt_errors), aes(x = Error, y = as.factor(Error))) +
  geom_boxplot() +
  labs(title = "Error Distribution for Decision Tree", x = "Error", y = "Frequency") +
  theme_minimal()

# Boxplot of Population distribution
ggplot(data_cleaned, aes(x = density_category, y = Population)) +
  geom_boxplot() +
  labs(title = "Population Distribution by Density Category", x = "Density Category", y = "Population") +
  theme_minimal()
