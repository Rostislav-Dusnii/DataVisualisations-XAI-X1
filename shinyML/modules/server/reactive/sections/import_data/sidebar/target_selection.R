# Define explanatory variables list (only numeric or integer)
available_targets <- reactive({
  numeric_cols <- sapply(current_dataset$data[, current_dataset$available_variables, with = FALSE], 
                         function(x) is.numeric(x) || is.integer(x))
  setdiff(current_dataset$available_variables[numeric_cols], dates_variable_list())
})

# Target selection UI
output$target_selection <- renderUI({
  selectInput(
    inputId = "target_selection",
    label = "Predict variable: ",
    choices = available_targets(),
    multiple = FALSE,
    selected = target$value
  )
})

# Update selected target
observeEvent(input$target_selection, {
  target$value <- input$target_selection
  target$results_table_value <- paste(target$value, " - target", sep = "")
})
