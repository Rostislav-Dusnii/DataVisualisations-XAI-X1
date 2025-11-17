# Define X-axis for input data chart
output$X_axis_explore_dataset <- renderUI({
  selected_column <- colnames(data)[1]
  selectInput(inputId = "x_variable_input_curve", label = "X-axis variable", choices = colnames(data), selected = selected_column)
})
