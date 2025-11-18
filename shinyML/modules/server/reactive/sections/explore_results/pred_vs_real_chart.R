output$pred_vs_real_chart <- renderDygraph({
  req(predictions()) # make sure predictions exist

  y <- target$value
  table_results <- predictions()[["table_results"]]
  req(y %in% colnames(table_results)) # ensure y column exists

  data_output_curve <- table_results %>%
    mutate(counter = row_number()) %>%
    select(counter, everything())

  max_y <- max(table_results[[y]], na.rm = TRUE)

  output_dygraph <- dygraph(data_output_curve, main = "Prediction results on test period") %>%
    dyAxis("x", valueRange = c(0, nrow(table_results))) %>%
    dyAxis("y", valueRange = c(0, 1.5 * max_y)) %>%
    dyOptions(animatedZooms = TRUE, fillGraph = TRUE, drawPoints = TRUE, pointSize = 2)

  if (isTRUE(input$bar_chart_mode)) {
    output_dygraph <- output_dygraph %>% dyBarChart()
  }

  output_dygraph %>% dyLegend(width = 800)
})
