# Define X-axis for input data chart
output$X_axis_explore_dataset <- renderUI({
  req(!is.null(input$checkbox_time_series))
  if (input$checkbox_time_series == TRUE) {
    req(!is.null(input$time_series_select_column))
    selected_column <- input$time_series_select_column
  } else {
    selected_column <- colnames(data)[1]
  }

  selectInput(inputId = "x_variable_input_curve", label = "X-axis variable", choices = colnames(data), selected = selected_column)
})
