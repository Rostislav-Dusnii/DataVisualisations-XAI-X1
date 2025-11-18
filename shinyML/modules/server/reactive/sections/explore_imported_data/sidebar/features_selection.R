available_features <- reactive({
  target_col <- target$value
  setdiff(available_variables, c(dates_variable_list(), target_col))
})

output$features_selection <- renderUI({
  selectInput(inputId = "features_selection", label = "Feature variables: ", choices = available_features(), multiple = TRUE, selected = available_features())
})

observeEvent(input$features_selection, {
  # Remove target from features if it is there
  selected_features <- setdiff(input$features_selection, target$value)
  features$list <- selected_features
})
