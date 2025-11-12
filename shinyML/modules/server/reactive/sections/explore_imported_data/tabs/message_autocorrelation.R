# Define indicating that autocorrelation plot is only available for time series
output$message_autocorrelation <- renderUI({
  points_serie <- eval(parse(text = paste0("data[,", colnames(data)[input$variables_class_input_rows_selected], "]")))
  if (input$input_var_graph_type %in% c("Histogram", "Autocorrelation") & !is.numeric(points_serie)) {
    argonH1("Only available for numerical variables", display = 4)
  }
})
