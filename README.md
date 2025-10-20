# DataVisualisations-XAI-X1

A Shiny R application for interactive data visualizations with Explainable AI (XAI) capabilities.

## Overview

This application provides an interactive interface for exploring datasets through various visualization techniques and understanding data relationships through explainable AI insights. It's designed to make data analysis accessible and interpretable.

## Features

### Data Visualization
- **Multiple Plot Types**: Scatter plots, box plots, histograms, and density plots
- **Interactive Plots**: All visualizations are powered by Plotly for interactive exploration
- **Dataset Options**: Pre-loaded datasets including Iris, mtcars, and diamonds
- **Customizable Views**: Select variables, grouping options, and color schemes

### Explainable AI (XAI)
- **Linear Model Analysis**: Fit and interpret linear models with confidence intervals
- **Feature Importance**: Visualize the relative importance of features based on variance
- **Correlation Analysis**: Identify and rank correlations between variables
- **Statistical Summaries**: Comprehensive statistical descriptions of your data

### Interactive Controls
- Dataset selection
- Plot type selection
- Variable selection for X, Y axes
- Grouping and coloring options
- Model fitting with adjustable confidence levels

## Installation

### Prerequisites
- R (version 4.0.0 or higher recommended)
- RStudio (optional but recommended)

### Required R Packages

Install the required packages using R:

```r
install.packages(c("shiny", "ggplot2", "plotly"))
```

## Usage

### Running the Application

#### Option 1: From RStudio
1. Open the `app.R` file in RStudio
2. Click the "Run App" button in the top-right corner of the editor

#### Option 2: From R Console
```r
# Set working directory to the app folder
setwd("/path/to/DataVisualisations-XAI-X1")

# Run the app
shiny::runApp()
```

#### Option 3: From Command Line
```bash
R -e "shiny::runApp('/path/to/DataVisualisations-XAI-X1')"
```

### Using the Application

1. **Select a Dataset**: Choose from Iris, mtcars, or diamonds datasets
2. **Choose Plot Type**: Select the type of visualization you want to create
3. **Configure Variables**: Select variables for your visualization
4. **Enable XAI Features**: Check "Show Linear Model" for scatter plots to see model fits
5. **Explore Tabs**:
   - **Visualization**: Interactive plots and data summary
   - **XAI Insights**: Model analysis, feature importance, and correlations
   - **Data Table**: Preview of the selected dataset
   - **About**: Application information and features

## Application Structure

```
DataVisualisations-XAI-X1/
├── app.R           # Main Shiny application file
├── README.md       # This file
└── .gitignore      # Git ignore configuration
```

## Technologies Used

- **Shiny**: Web application framework for R
- **ggplot2**: Grammar of graphics for creating visualizations
- **Plotly**: Interactive plotting library

## XAI Capabilities

The application provides several explainability features:

1. **Model Interpretation**: When fitting linear models, the app provides:
   - Coefficients and their meanings
   - R-squared values for model fit quality
   - P-values for statistical significance
   - Plain-language interpretation of relationships

2. **Feature Importance**: Visual representation of which features have the most variance and potential impact on analysis

3. **Correlation Discovery**: Automatic identification of the strongest correlations in your dataset

4. **Statistical Context**: Comprehensive summaries to understand data distribution and characteristics

## Example Use Cases

1. **Exploring the Iris Dataset**: Analyze relationships between sepal/petal measurements across species
2. **Automotive Analysis**: Understand relationships between car characteristics in the mtcars dataset
3. **Diamond Pricing**: Explore factors affecting diamond prices in the diamonds dataset

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is open source and available under the MIT License.

## Author

Created for data visualization and explainable AI demonstrations.