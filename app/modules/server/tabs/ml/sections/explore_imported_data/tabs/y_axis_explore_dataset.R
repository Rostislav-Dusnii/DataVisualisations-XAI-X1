# y-axis variable selector
output$y_axis_explore_dataset <- renderUI({
  selectInput(inputId = "y_variable_input_curve", label = "Y-axis variable", choices = current_dataset$available_variables, selected = target$value)
})
