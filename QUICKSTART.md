# Quick Start Guide

## Installation Steps

1. **Install R**
   - Download from: https://cran.r-project.org/
   - Install version 4.0.0 or higher

2. **Install Required Packages**
   Open R or RStudio and run:
   ```r
   install.packages(c("shiny", "ggplot2", "plotly"))
   ```

3. **Clone or Download this Repository**
   ```bash
   git clone https://github.com/Rostislav-Dusnii/DataVisualisations-XAI-X1.git
   cd DataVisualisations-XAI-X1
   ```

4. **Run the Application**
   ```r
   shiny::runApp()
   ```
   Or open `app.R` in RStudio and click "Run App"

## First Time Use

When you first run the application:

1. The app will open in your default web browser
2. Start with the **Iris** dataset (default)
3. Try different **Plot Types** from the sidebar
4. Navigate through the tabs to see different views
5. Enable "Show Linear Model" on scatter plots to see XAI analysis

## Troubleshooting

### Package Installation Issues
If you encounter package installation errors:
```r
# Try installing from CRAN mirror
install.packages("shiny", repos = "https://cran.rstudio.com/")
install.packages("ggplot2", repos = "https://cran.rstudio.com/")
install.packages("plotly", repos = "https://cran.rstudio.com/")
```

### Port Already in Use
If you get a "port already in use" error:
```r
# Specify a different port
shiny::runApp(port = 8888)
```

### Browser Doesn't Open
If the browser doesn't open automatically:
- Look for the URL in the R console (usually http://127.0.0.1:XXXX)
- Copy and paste it into your browser

## Tips for Best Experience

1. **Use RStudio**: Provides the best development experience
2. **Try Different Datasets**: Each has unique characteristics
3. **Explore All Plot Types**: Different visualizations reveal different insights
4. **Use XAI Features**: Enable linear models to understand relationships
5. **Check Correlations**: Visit the XAI Insights tab for correlation analysis

## Next Steps

- Modify `app.R` to add your own datasets
- Customize visualizations and colors
- Extend XAI capabilities with additional models
- Share your application with others

For more information, see the main README.md file.
