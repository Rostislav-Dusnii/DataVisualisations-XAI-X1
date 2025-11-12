# Checkbox to consider time serie analysis or not (only possible if input dataset contains at least one Date or POSIXct column)
output$time_series_checkbox <- renderUI({
  if (length(dates_variable_list()) >= 1) {
    value <- TRUE
  } else {
    value <- FALSE
  }

  awesomeCheckbox("checkbox_time_series", "Time series", status = "primary", value = value)
})

# Hide checkbox if input dataset does not contain one or more Date or POSIXct column
observe({
  if (length(dates_variable_list()) == 0) {
    shinyjs::hideElement("time_series_checkbox")
  }
})

# Set test_1 and test_2 parameters (only applicable for time series analysis)
observe({
  req(!is.null(input$checkbox_time_series))
  if (input$checkbox_time_series == TRUE) {
    req(!is.null(input$time_series_select_column))
    test_1$date <- eval(parse(text = paste0("mean(as.Date(data$", input$time_series_select_column, "))")))
    test_2$date <- eval(parse(text = paste0("max(as.Date(data$", input$time_series_select_column, "))")))
  }
})
