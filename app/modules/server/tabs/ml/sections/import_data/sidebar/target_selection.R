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
