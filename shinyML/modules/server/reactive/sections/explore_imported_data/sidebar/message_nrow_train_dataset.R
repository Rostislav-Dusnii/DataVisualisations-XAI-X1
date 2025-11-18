# Define indicating number of rows contained in testing dataset
output$message_nrow_train_dataset <- renderUI({
  train_data <- train_test_data()$data_train
  req(!is.null(train_data))
  number_rows_datatest <- nrow(train_data)

  argonBadge(text = HTML(paste0(
    "<big><big>Training dataset contains <b>",
    number_rows_datatest,
    "</b> samples</big></big>"
  )), status = "success")
})
