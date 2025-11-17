# Define explanatory variables list
output$input_variables_selection <- renderUI({
  variable_input_list <- x[!(x %in% dates_variable_list())]
  selectInput(inputId = "input_variables", label = "Input variables: ", choices = x, multiple = TRUE, selected = variable_input_list)
})
