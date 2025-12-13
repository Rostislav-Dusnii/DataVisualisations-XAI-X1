# target variable dropdown
output$target_selection <- renderUI({
  selectInput(
    inputId = "target_selection",
    label = "Predict variable: ",
    choices = available_targets(),
    multiple = FALSE,
    selected = target$value
  )
})

# update target on selection change
observeEvent(input$target_selection, {
  target$value <- input$target_selection
  target$results_table_value <- paste(target$value, " - target", sep = "")
})
