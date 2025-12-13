# calculates MAPE and RMSE for each model
performance_data <- eventReactive(predictions()[["table_results"]], {
  table_results <- predictions()[["table_results"]]
  req(!is.null(table_results))
  req(ncol(table_results) > ncol(current_dataset$data))

  y <- isolate(target$results_table_value)

  performance_table <- table_results %>%
    select(-features$list) %>%
    gather(key = Model, value = Predicted_value, -all_of(y)) %>%
    as.data.table()

  performance_table <- performance_table %>%
    group_by(Model) %>%
    summarise(
      mape = round(
        100 * mean(abs((Predicted_value - .data[[y]]) / .data[[y]]), na.rm = TRUE),
        1
      ),
      rmse = round(sqrt(mean((Predicted_value - .data[[y]])^2, na.rm = TRUE)), 2),
      .groups = "drop"
    )

  training_time <- isolate(model_training_results()[["table_training_time"]])
  if (!is.null(training_time) && nrow(training_time) > 0) {
    performance_table <- performance_table %>%
      left_join(training_time, by = "Model")
  }

  setnames(performance_table, old = c("mape", "rmse"), new = c("MAPE(%)", "RMSE"))
  performance_table
})

output$model_performance_comparison <- renderDT({
  datatable(
    performance_data() %>% arrange(`MAPE(%)`) %>% as.data.table(),
    extensions = "Buttons",
    options = list(dom = "Bfrtip", buttons = c("csv", "excel", "pdf", "print"))
  )
})


# alert when no models trained
output$message_compare_models_performances <- renderUI({
  trained_models <- model_training_results()$trained_models
  if (length(trained_models) <= 0) {
    sendSweetAlert(
      session = session,
      title = "",
      text = "Please run at least one algorithm to check model performances !",
      type = "error"
    )

    argonH1("Please run at least one algorithm to check model performances !", display = 4)
  }
})
