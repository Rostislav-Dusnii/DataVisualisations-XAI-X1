# badge showing training sample count
output$message_nrow_train_dataset <- renderUI({
  train_data <- train_test_data()$data_train
  req(!is.null(train_data))
  number_rows_datatest <- nrow(train_data)

  argonBadge(text = HTML(paste0(
    number_rows_datatest,
    "</b> training samples</big></big>"
  )), status = "success")
})
