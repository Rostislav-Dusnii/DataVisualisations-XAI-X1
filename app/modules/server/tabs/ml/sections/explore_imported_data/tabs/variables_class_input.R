# table showing variable names and their data types
output$variables_class_input <- renderDT({
  req(current_dataset$data, current_dataset$available_variables)

  table_classes <- data.table(
    Variable = current_dataset$available_variables,
    Class = sapply(current_dataset$available_variables, function(col) {
      cls <- class(current_dataset$data[[col]])
      paste(cls, collapse = ", ")
    })
  )

  datatable(
    table_classes,
    options = list(pageLength = 10, searching = FALSE, lengthChange = FALSE),
    selection = list(mode = "single", selected = c(1))
  )
})
