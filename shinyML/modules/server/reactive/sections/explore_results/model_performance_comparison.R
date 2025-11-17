# Define performance table visible on "Compare models performances" tab
output$model_performance_comparison <- renderDT({
  table_results <- predictions()[["table_results"]]
  req(!is.null(table_results))
  req(ncol(table_results) > ncol(data))

  # Gather prediction columns into long format
  performance_table <- table_results %>%
    select(-c(setdiff(colnames(data), y))) %>%
    gather(key = Model, value = Predicted_value, -y) %>%
    as.data.table()

  # Compute performance metrics
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

  # Merge training time if available
  training_time <- model_training_results()[["table_training_time"]]
  if (!is.null(training_time) && nrow(training_time) > 0) {
    performance_table <- performance_table %>%
      left_join(training_time, by = "Model")
  }
  # Render datatable
  datatable(
    performance_table %>% arrange(mape) %>% as.data.table(),
    extensions = "Buttons",
    options = list(dom = "Bfrtip", buttons = c("csv", "excel", "pdf", "print"))
  )
  setnames(performance_table, old = c("mape", "rmse"), new = c("MAPE(%)", "RMSE"))
})


# Message indicating that results are not available if no model has been running
output$message_compare_models_performances <- renderUI({
  table_results <- predictions()[["table_results"]]
  if (ncol(table_results) <= ncol(data)) {
    sendSweetAlert(
      session = session,
      title = "",
      text = "Please run at least one algorithm to check model performances !",
      type = "error"
    )

    argonH1("Please run at least one algorithm to check model performances !", display = 4)
  }
})
