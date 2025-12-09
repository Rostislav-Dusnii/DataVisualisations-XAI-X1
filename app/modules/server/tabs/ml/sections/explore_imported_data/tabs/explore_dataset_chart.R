# Define plotly chart to explore dependencies between variables
output$dataset_chart <- renderPlotly({
  req(!is.null(input$x_variable_input_curve))
  req(!is.null(input$y_variable_input_curve))

  req(!is.null(train_test_data()[["data_train"]]))
  data_train_chart <- train_test_data()[["data_train"]]
  data_test_chart <- train_test_data()[["data_test"]]

  plot_ly(
    data = data_train_chart, x = eval(parse(text = paste0("data_train_chart$", input$x_variable_input_curve))),
    y = eval(parse(text = paste0("data_train_chart$", input$y_variable_input_curve))),
    type = "scatter", mode = "markers",
    name = "Training dataset"
  ) %>%
    add_trace(
      x = eval(parse(text = paste0("data_test_chart$", input$x_variable_input_curve))),
      y = eval(parse(text = paste0("data_test_chart$", input$y_variable_input_curve))),
      type = "scatter", mode = "markers",
      name = "Testing dataset"
    ) %>%
    layout(xaxis = list(title = input$x_variable_input_curve), yaxis = list(title = input$y_variable_input_curve), legend = list(orientation = "h", xanchor = "center", x = 0.5, y = 1.2))
})
