# predictions table with export buttons
output$table_of_results <- renderDT(
  {
    datatable(
      predictions()[["table_results"]],
      extensions = "Buttons", options = list(dom = "Bfrtip", buttons = c("csv", "excel", "pdf", "print"))
    )
  },
  server = FALSE
)
