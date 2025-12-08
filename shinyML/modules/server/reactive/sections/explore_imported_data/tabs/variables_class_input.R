# Define input data summary with class of each variable
output$variables_class_input <- renderDT({
  table_classes <- data.table()

  for (i in 1:ncol(data)) {
    table_classes <- rbind(
      table_classes,
      data.frame(
        Variable = current_dataset$available_variables[i],
        Class = class(eval(parse(text = paste0("data$", current_dataset$available_variables[i]))))
      )
    )
  }

  datatable(table_classes, options = list(pageLength = 10, searching = FALSE, lengthChange = FALSE), selection = list(mode = "single", selected = c(1)))
})
