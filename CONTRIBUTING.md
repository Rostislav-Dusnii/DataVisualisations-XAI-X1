# Contributing to Data Visualizations XAI

Thank you for your interest in contributing to this project! This guide will help you get started.

## How to Contribute

### Reporting Bugs
1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your R version and package versions
   - Screenshots if applicable

### Suggesting Enhancements
1. Create an issue describing:
   - The enhancement and its benefits
   - Possible implementation approach
   - Any potential drawbacks

### Pull Requests
1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a pull request

## Development Setup

1. **Install R and RStudio**
   - R version 4.0.0 or higher
   - Latest version of RStudio

2. **Install Dependencies**
   ```r
   install.packages(c("shiny", "ggplot2", "plotly"))
   ```

3. **Clone the Repository**
   ```bash
   git clone https://github.com/Rostislav-Dusnii/DataVisualisations-XAI-X1.git
   cd DataVisualisations-XAI-X1
   ```

4. **Test the Application**
   ```r
   shiny::runApp()
   ```

## Code Style Guidelines

### R Code Style
- Use snake_case for variable names
- Use camelCase for function names (to match Shiny conventions)
- Indent with 2 spaces
- Maximum line length: 80 characters (when practical)
- Add comments for complex logic

Example:
```r
# Good
calculate_correlation <- function(data, var1, var2) {
  result <- cor(data[[var1]], data[[var2]], use = "complete.obs")
  return(result)
}

# Avoid
calculatecorrelation<-function(x,y){cor(x,y)}
```

### Shiny Specific
- Keep UI and server logic separate
- Use reactive expressions for repeated calculations
- Use `req()` to prevent errors from NULL inputs
- Add meaningful IDs to UI elements

### Comments
- Explain WHY, not WHAT
- Document function parameters
- Add section headers for organization

Example:
```r
# Calculate feature importance based on variance
# Using normalized variance as a simple proxy for importance
# More sophisticated methods (SHAP, permutation) could be added later
calculate_feature_importance <- function(data) {
  # Implementation...
}
```

## Testing

### Manual Testing Checklist
Before submitting a PR, test:
- [ ] All plot types render correctly
- [ ] Variable selection updates properly
- [ ] Model fitting works (scatter plots)
- [ ] XAI insights calculate correctly
- [ ] All tabs display content
- [ ] No console errors
- [ ] Works with all three datasets

### Test Each Feature
1. **Data Selection**: Switch between datasets
2. **Visualizations**: Try all plot types with different variables
3. **Model Fitting**: Enable/disable, adjust confidence levels
4. **XAI Analysis**: Verify calculations are correct
5. **Responsiveness**: Resize browser window

## Adding New Features

### Adding a New Dataset
1. Add data source (CSV or R dataset)
2. Update dataset choices in UI
3. Add case in `selected_data` reactive
4. Test with all plot types

Example:
```r
# In UI
selectInput("dataset", "Choose a dataset:",
            choices = c("Iris", "mtcars", "diamonds", "New Dataset"))

# In server
selected_data <- reactive({
  data <- switch(input$dataset,
                 "Iris" = iris,
                 "mtcars" = mtcars,
                 "diamonds" = diamonds[sample(nrow(diamonds), 1000), ],
                 "New Dataset" = read.csv("data/new_data.csv"))
  return(data)
})
```

### Adding a New Plot Type
1. Add option to plot type dropdown
2. Add conditional panel if needed (for specific controls)
3. Implement in `output$main_plot`
4. Test with all datasets

Example:
```r
# In UI
selectInput("plot_type", "Plot Type:",
            choices = c("Scatter Plot", "Box Plot", "Histogram", 
                       "Density Plot", "Violin Plot"))

# In server
} else if (input$plot_type == "Violin Plot") {
  req(input$single_var)
  p <- ggplot(data, aes_string(x = input$group_var, y = input$single_var)) +
    geom_violin(fill = "steelblue") +
    theme_minimal() +
    labs(title = paste("Violin Plot of", input$single_var))
}
```

### Adding XAI Features
1. Consider computational cost
2. Add clear explanations in plain language
3. Provide visualizations when possible
4. Document statistical methods used

Example areas for enhancement:
- SHAP values for non-linear models
- Random Forest importance
- Partial dependence plots
- Interaction effects
- Cross-validation metrics

## Documentation

When adding features, update:
- [ ] `README.md` - If adding major features
- [ ] `EXAMPLES.md` - Add usage examples
- [ ] `UI_GUIDE.md` - If changing UI layout
- [ ] Code comments - Explain complex logic
- [ ] `DESCRIPTION` - If adding package dependencies

## Package Dependencies

When adding new packages:
1. Check if already available
2. Prefer CRAN packages
3. Update `DESCRIPTION` file
4. Update installation instructions
5. Consider lightweight alternatives

Example:
```r
# In DESCRIPTION
Imports:
    shiny (>= 1.7.0),
    ggplot2 (>= 3.4.0),
    plotly (>= 4.10.0),
    newpackage (>= 1.0.0)
```

## Git Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-plot-type
   ```

2. **Make Changes and Commit**
   ```bash
   git add .
   git commit -m "Add violin plot option"
   ```

3. **Keep Updated with Main**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/new-plot-type
   ```

## Commit Message Guidelines

Format:
```
<type>: <short description>

<detailed description>

<breaking changes if any>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, no logic change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat: Add violin plot visualization option

Implements violin plot as a new plot type for better distribution
visualization. Users can now select "Violin Plot" from the plot
type dropdown.

fix: Correct correlation calculation for datasets with NA values

Added use="complete.obs" parameter to cor() function to handle
missing values gracefully.
```

## Code Review Process

When reviewing PRs:
1. Check code style and consistency
2. Verify functionality works as described
3. Test edge cases
4. Review documentation updates
5. Check for potential performance issues
6. Ensure backward compatibility

## Questions?

If you have questions:
- Open an issue with the "question" label
- Check existing issues for similar questions
- Review the documentation files

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing! 🎉
