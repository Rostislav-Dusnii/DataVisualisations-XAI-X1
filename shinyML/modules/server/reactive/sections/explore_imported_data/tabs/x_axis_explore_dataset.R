# Define X-axis for input data chart
output$x_axis_explore_dataset <- renderUI({
  selected_column <- available_variables[1]
  selectInput(inputId = "x_variable_input_curve", label = "X-axis variable", choices = available_variables, selected = selected_column)
})
