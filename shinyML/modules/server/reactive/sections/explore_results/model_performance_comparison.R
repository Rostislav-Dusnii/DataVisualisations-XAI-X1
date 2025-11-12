# Define performance table visible on "Compare models performances" tab
output$model_performance_comparison <- renderDT({
  req(ncol(table_forecast()[["results"]]) > ncol(data))
  req(!is.null(input$checkbox_time_series))

  if (input$checkbox_time_series == TRUE) {
    req(!is.null(input$time_series_select_column))

    performance_table <- eval(parse(text = paste0("table_forecast()[['results']] %>%
                                                         gather(key = Model,value = Predicted_value,-", input$time_series_select_column, ",-y) %>%
                                                         as.data.table()")))
  } else if (input$checkbox_time_series == FALSE) {
    performance_table <- table_forecast()[["results"]] %>%
      select(-c(setdiff(colnames(data), y))) %>%
      gather(key = Model, value = Predicted_value, -y) %>%
      as.data.table()
  }

  performance_table <- performance_table %>%
    group_by(Model) %>%
    summarise(
      `MAPE(%)` = round(100 * mean(abs((Predicted_value - eval(parse(text = y))) / eval(parse(text = y))), na.rm = TRUE), 1),
      RMSE = round(sqrt(mean((Predicted_value - eval(parse(text = y)))**2)), 2)
    )


  if (nrow(table_forecast()[["traning_time"]]) != 0) {
    performance_table <- performance_table %>% merge(., table_forecast()[["traning_time"]], by = "Model")
  }

  datatable(
    performance_table %>% arrange(`MAPE(%)`) %>% as.data.table(),
    extensions = "Buttons", options = list(dom = "Bfrtip", buttons = c("csv", "excel", "pdf", "print"))
  )
})


# Message indicating that results are not available if no model has been running
output$message_compare_models_performances <- renderUI({
  if (ncol(table_forecast()[["results"]]) <= ncol(data)) {
    sendSweetAlert(
      session = session,
      title = "",
      text = "Please run at least one algorithm to check model performances !",
      type = "error"
    )

    argonH1("Please run at least one algorithm to check model performances !", display = 4)
  }
})
