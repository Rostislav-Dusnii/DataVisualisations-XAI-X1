# Define results table
output$table_of_results <- renderDT(
  {
    datatable(
      table_forecast()[["results"]],
      extensions = "Buttons", options = list(dom = "Bfrtip", buttons = c("csv", "excel", "pdf", "print"))
    )
  },
  server = FALSE
)
