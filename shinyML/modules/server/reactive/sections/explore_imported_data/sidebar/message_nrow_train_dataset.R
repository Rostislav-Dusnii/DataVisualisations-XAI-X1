# Define indicating number of rows contained in testing dataset
output$message_nrow_train_dataset <- renderUI({
  req(!is.null(input$checkbox_time_series))
  req(!is.null(train_test_data()[["train"]]))

  if (input$checkbox_time_series == TRUE) {
    number_rows_datatest <- nrow(eval(parse(text = paste0("data[", input$time_series_select_column, " >= input$train_selector[1],][", input$time_series_select_column, " <= input$train_selector[2],]"))))
  } else if (input$checkbox_time_series == FALSE) {
    number_rows_datatest <- nrow(train_test_data()[["train"]])
  }

  argonBadge(text = HTML(paste0("<big><big>Training dataset contains <b>", number_rows_datatest, "</b> rows</big></big>")), status = "success")
})
