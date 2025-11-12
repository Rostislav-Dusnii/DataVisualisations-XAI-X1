# Define selectInput to choose which Date or POSIXct column to use among input dataset colnames (only applicable for time series analysis)
output$time_series_column <- renderUI({
  req(!is.null(input$checkbox_time_series))
  if (input$checkbox_time_series == TRUE) {
    selectInput(inputId = "time_series_select_column", label = "Date column", choices = dates_variable_list(), multiple = FALSE)
  }
})
