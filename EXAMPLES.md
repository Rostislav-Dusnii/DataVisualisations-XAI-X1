# Application Screenshots and Examples

## Main Interface

The application consists of 4 main tabs:

### 1. Visualization Tab
This tab displays interactive plots with the following features:
- **Plot Types**: Scatter, Box, Histogram, Density
- **Interactive Controls**: Zoom, pan, hover for details
- **Linear Model Overlay**: Optional trend lines with confidence intervals
- **Data Summary**: Quick overview of dataset dimensions

**Example Use Case**: 
- Select "Iris" dataset
- Choose "Scatter Plot"
- X Variable: Sepal.Length
- Y Variable: Petal.Length
- Color By: Species
- Enable "Show Linear Model"

Result: An interactive scatter plot showing the relationship between sepal and petal length, colored by species, with a fitted linear model and 95% confidence interval.

### 2. XAI Insights Tab
Provides explainable AI analysis including:
- **Linear Model Summary**: Coefficients, R-squared, p-values
- **Model Interpretation**: Plain-language explanations of relationships
- **Correlation Matrix**: Top correlations in the dataset
- **Feature Importance**: Bar chart showing relative importance of features

**Example Analysis** (Iris dataset, Petal.Length vs Sepal.Length):
```
Linear Model Summary:
- R-squared: 0.76
- P-value: < 0.001
- Interpretation: Significant positive correlation

Feature Importance:
1. Petal.Length (35%)
2. Petal.Width (28%)
3. Sepal.Length (22%)
4. Sepal.Width (15%)
```

### 3. Data Table Tab
Shows a preview of the selected dataset with:
- First 20 rows
- All columns
- Formatted values

### 4. About Tab
Information about the application:
- Features list
- Technologies used
- Usage instructions

## Workflow Examples

### Example 1: Exploring Iris Dataset
1. Open the app
2. Default dataset is Iris
3. Try different plot types:
   - Scatter: See species separation
   - Box Plot: Compare distributions
   - Histogram: View individual variable distributions
4. Visit XAI Insights to understand correlations
5. Enable linear model to quantify relationships

### Example 2: Analyzing mtcars Dataset
1. Select "mtcars" from dataset dropdown
2. Choose Scatter Plot
3. X Variable: wt (weight)
4. Y Variable: mpg (miles per gallon)
5. Color By: cyl (cylinders)
6. Enable linear model
7. Observe negative correlation: heavier cars have lower MPG
8. Check XAI Insights for statistical confirmation

### Example 3: Examining Diamonds Dataset
1. Select "diamonds" dataset (sampled to 1000 rows for performance)
2. Try Density Plot
3. Variable: price
4. Group By: cut
5. Observe price distributions across different cut qualities
6. Visit XAI Insights for correlation analysis between price, carat, and cut

## Key Features Demonstrated

### Interactive Visualization
- Hover over points to see exact values
- Zoom into specific regions
- Pan across the plot
- Toggle legend items

### Explainable AI
- Clear statistical metrics (R-squared, p-values)
- Plain-language interpretations
- Visual feature importance
- Correlation discovery

### Flexibility
- Multiple datasets
- Various plot types
- Customizable variables
- Grouping and coloring options

## Technical Details

### Datasets
- **Iris**: 150 rows, 5 columns (4 numeric, 1 categorical)
- **mtcars**: 32 rows, 11 columns (all numeric)
- **diamonds**: 1000 rows (sampled), 10 columns (7 numeric, 3 categorical)

### Plot Types
- **Scatter**: Best for bivariate relationships
- **Box**: Best for distribution comparison
- **Histogram**: Best for frequency distribution
- **Density**: Best for smooth distribution visualization

### XAI Metrics
- **R-squared**: Proportion of variance explained (0-1)
- **P-value**: Statistical significance (< 0.05 is significant)
- **Correlation**: Strength and direction of relationships (-1 to 1)
- **Feature Importance**: Based on normalized variance

## Performance Notes

The application is optimized for:
- Small to medium datasets (up to 10,000 rows)
- Large datasets are automatically sampled (e.g., diamonds)
- Interactive plots update in real-time
- Reactive programming minimizes recalculation

## Future Enhancements

Potential additions:
- Custom dataset upload
- More advanced ML models (Random Forest, XGBoost)
- SHAP values for deeper explainability
- Export plots as images
- Download filtered data
- More plot types (3D scatter, heatmaps, etc.)
- Time series analysis
