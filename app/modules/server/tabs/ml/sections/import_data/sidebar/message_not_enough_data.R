# warning badge when training data < 50 rows
output$message_not_enough_data <- renderUI({
  train_data <- train_test_data()$data_train
  req(!is.null(train_data))
  number_rows_datatest <- nrow(train_data)

  if (number_rows_datatest < 50) {
    argonBadge(
            text = HTML(paste0(
            "</b> there is not enough data</big></big>"
            )),
            status = "warning"
        )
    }
})
