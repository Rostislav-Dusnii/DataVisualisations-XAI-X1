# Define indicating number of rows contained in training dataset
output$message_not_enough_data <- renderUI({
  train_data <- train_test_data()$data_train
  req(!is.null(train_data))
  number_rows_datatest <- nrow(train_data)

  # Set badge status based on number of rows
    if (number_rows_datatest < 50) {
  # Show badge with message
        argonBadge(
            text = HTML(paste0(
            "</b> there is not enough data</big></big>"
            )),
            status = "warning"
        )
    }
})
