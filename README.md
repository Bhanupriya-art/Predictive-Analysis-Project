# State-Wise Population Density Prediction

This R project aims to analyze state-wise population data and predict population density categories (Low, Medium, High) based on various demographic factors. The project compares the performance of three machine learning models: Decision Tree, K-Nearest Neighbors (KNN), and Naive Bayes, in predicting population density categories.

## Project Overview

The project follows these main steps:

1. **Data Loading**: Load the dataset containing state-wise population, growth rate, and population density.
2. **Data Preprocessing**: Clean the data by removing irrelevant rows, handling missing values, and creating new features, such as density categories based on population density.
3. **Feature Scaling**: Scale the features to standardize them before model training.
4. **Model Training**: Train three machine learning models—Decision Tree, KNN, and Naive Bayes—on the preprocessed data.
5. **Model Evaluation**: Evaluate the models using confusion matrices and calculate accuracy for comparison.
6. **Visualization**: Generate various plots, including confusion matrix heatmaps, accuracy comparison bar charts, and scatter/box plots for data insights.

## Requirements

To run this project, you will need the following R libraries:

- `tidyverse`
- `caret`
- `rpart`
- `class`
- `e1071`
- `pROC`
- `reshape2`
- `ggplot2`

You can install the necessary packages using the following command:

```r
install.packages(c("tidyverse", "caret", "rpart", "class", "e1071", "pROC", "reshape2", "ggplot2"))
```

## How to Run the Code
1. Clone this repository to your local machine:
```bash
git clone https://github.com/yourusername/your-repository-name.git
```
2. Set the working directory in R to the folder where the project is located.
3. Load the dataset (```State-wise Population, Decadal Population Growth rate and Population Density - 2011.csv```) and make sure it is in the same folder or adjust the file path in the script.
4. Run the script to load, preprocess, train the models, and visualize the results.

## Results
The project generates various plots to help visualize the model's performance, such as:

- Confusion Matrix Heatmaps for each model (Decision Tree, KNN, Naive Bayes)
- Model Accuracy Comparison bar chart
- Population Distribution boxplot by density category
- Scatter Plots showing relationships between population, growth rate, and density categories

## Conclusion
The project provides insights into how different machine learning models perform in predicting population density categories, as well as visualizations to support data exploration and analysis.

Feel free to contribute to the repository or use it for your own analysis!



