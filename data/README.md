# Custom Dataset Examples

This directory can contain custom datasets for use with the Shiny application.

## Adding Your Own Dataset

1. **Create a CSV file** with your data in this directory
2. **Modify app.R** to load your dataset:

```r
# In app.R, find the selectInput for dataset and add your dataset:
selectInput("dataset", "Choose a dataset:",
            choices = c("Iris", "mtcars", "diamonds", "Custom Data"))

# Then in the selected_data reactive, add:
selected_data <- reactive({
  data <- switch(input$dataset,
                 "Iris" = iris,
                 "mtcars" = mtcars,
                 "diamonds" = diamonds[sample(nrow(diamonds), 1000), ],
                 "Custom Data" = read.csv("data/your_data.csv"))
  return(data)
})
```

## Dataset Requirements

For best results with the XAI features:

- Include at least 2-3 numeric columns for correlation analysis
- Include categorical columns for grouping (optional)
- Use clear, descriptive column names
- Ensure no missing values or handle them appropriately

## Example Dataset Structure

Here's an example CSV structure:

```csv
feature1,feature2,feature3,category
10.5,20.3,30.1,A
12.3,22.1,28.5,B
11.8,21.5,29.3,A
13.2,23.8,27.9,C
```

Save this as `example_data.csv` in this directory and load it using the instructions above.
