# Define output chart comparing predicted vs real values on test period for selected model(s)
output$pred_vs_real_chart <- renderDygraph({
  req(!is.null(input$checkbox_time_series))

  if (input$checkbox_time_series == TRUE) {
    req(!is.null(input$time_series_select_column))
    data_output_curve <- table_forecast()[["results"]] %>% select(-input$input_variables)
  } else if (input$checkbox_time_series == FALSE) {
    data_output_curve <- table_forecast()[["results"]] %>%
      select(-c(setdiff(colnames(data), y))) %>%
      mutate(Counter = row_number()) %>%
      select(Counter, everything())
  }

  output_dygraph <- dygraph(data = data_output_curve, main = "Prediction results on test period", width = "100%", height = "150%") %>%
    dyAxis("x", valueRange = c(0, nrow(data))) %>%
    dyAxis("y", valueRange = c(0, 1.5 * max(eval(parse(text = paste0("table_forecast()[['results']]$", y)))))) %>%
    dyOptions(animatedZooms = TRUE, fillGraph = T, drawPoints = TRUE, pointSize = 2)


  # chart can be displayed with bar or line mode
  if (input$bar_chart_mode == TRUE) {
    output_dygraph <- output_dygraph %>% dyBarChart()
  }

  output_dygraph %>% dyLegend(width = 800)
})
