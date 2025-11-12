# Define slider percentage to separate training dataset from testing dataset
output$train_test_split_slider <- renderUI({
  req(!is.null(input$checkbox_time_series))

  if (input$checkbox_time_series == FALSE) {
    selectInput(label = "Train/ Test splitting", inputId = "train_test_split_slider", choices = paste0(c(50:99), "%"), selected = 70, multiple = FALSE)
  }
})


# Define train slider (only applicable for time series analysis)
output$slider_time_series_train <- renderUI({
  req(!is.null(input$checkbox_time_series))
  req(!is.null(input$time_series_select_column))

  if (input$checkbox_time_series == TRUE) {
    sliderInput("train_selector", "Choose train period:",
      min = eval(parse(text = paste0("min(data$", input$time_series_select_column, ")"))),
      max = eval(parse(text = paste0("max(data$", input$time_series_select_column, ")"))),
      value = eval(parse(text = paste0("c(min(data$", input$time_series_select_column, "),mean(data$", input$time_series_select_column, "))")))
    )
  }
})


# Synchronize train and test cursors
observeEvent(input$train_selector, {
  updateSliderInput(session, "test_selector",
    value = c(input$train_selector[2], input$test_selector[2])
  )
})
observeEvent(input$test_selector, {
  updateSliderInput(session, "train_selector",
    value = c(input$train_selector[1], input$test_selector[1])
  )
})
