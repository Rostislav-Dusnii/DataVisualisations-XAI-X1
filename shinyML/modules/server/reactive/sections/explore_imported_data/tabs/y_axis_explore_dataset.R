# Define X-axis for input data chart
output$y_axis_explore_dataset <- renderUI({
  selectInput(inputId = "y_variable_input_curve", label = "Y-axis variable", choices = available_variables, selected = target$value)
})
