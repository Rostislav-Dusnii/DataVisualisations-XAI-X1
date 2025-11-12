# Define explanatory variables list
output$input_variables_selection <- renderUI({
  req(!is.null(input$checkbox_time_series))
  variable_input_list <- x[!(x %in% dates_variable_list())]
  selectInput(inputId = "input_variables", label = "Input variables: ", choices = x, multiple = TRUE, selected = variable_input_list)
})
