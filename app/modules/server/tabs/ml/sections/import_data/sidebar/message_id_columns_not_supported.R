# warning badge for removed ID columns
output$message_id_columns_not_supported <- renderUI({
  id_columns <- current_dataset$id_columns
  number_of_ids <- length(id_columns)

  if (number_of_ids > 0) {
    message_text <- paste0(
      "ID-like columns are not supported for modeling and were removed: ",
      paste(id_columns, collapse = ", ")
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
