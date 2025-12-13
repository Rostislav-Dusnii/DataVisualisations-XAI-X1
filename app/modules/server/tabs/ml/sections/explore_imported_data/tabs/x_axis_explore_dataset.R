# x-axis variable selector
output$x_axis_explore_dataset <- renderUI({
  selected_column <- current_dataset$available_variables[1]
  selectInput(inputId = "x_variable_input_curve", label = "X-axis variable", choices = current_dataset$available_variables, selected = selected_column)
})
