# feature variable multi-select
output$features_selection <- renderUI({
  selectInput(inputId = "features_selection", label = "Feature variables: ", choices = available_features(), multiple = TRUE, selected = available_features())
})

# update features list on selection change
observeEvent(input$features_selection, {
  selected_features <- setdiff(input$features_selection, target$value)
  features$list <- selected_features
})
