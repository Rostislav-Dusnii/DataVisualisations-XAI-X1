# Define explanatory variables list
available_targets <- reactive({
  setdiff(available_variables, dates_variable_list())
})

output$target_selection <- renderUI({
  selectInput(
    inputId = "target_selection",
    label = "Predict variable: ",
    choices = available_targets(),
    multiple = FALSE,
    selected = target$value
  )
})


observeEvent(input$target_selection, {
  target$value <- input$target_selection
})
