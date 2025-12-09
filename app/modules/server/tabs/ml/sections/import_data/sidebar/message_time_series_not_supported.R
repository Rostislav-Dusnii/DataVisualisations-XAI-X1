output$message_time_series_not_supported <- renderUI({
  ts_columns <- dates_variable_list()  # columns detected as date / POSIXct
  number_of_ts <- length(ts_columns)

  if (number_of_ts > 0) {
    message_text <- paste0(
      "Time series data is not supported. The following columns were discarded: ",
      paste(ts_columns, collapse = ", ")
    )

    argonBadge(
      text = tags$div(
        style = "white-space: normal;",  # allows text to wrap
        message_text
      ),
      status = "dark"
    )
  }
})
