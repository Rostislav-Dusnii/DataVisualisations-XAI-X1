# data preview buttons with different display modes
observeEvent(input$show1, {
  show_data(data = current_dataset$data, title = current_dataset$title, type = "popup")
})

observeEvent(input$show2, {
  show_data(data = current_dataset$data, title = current_dataset$title, type = "modal")
})

observeEvent(input$show3, {
  show_data(data = current_dataset$data, title = current_dataset$title,
            show_classes = FALSE, options = list(pagination = 10), type = "modal")
})

observeEvent(input$show4, {
  show_data(data = current_dataset$data, title = current_dataset$title,
            type = "winbox", wbOptions = shinyWidgets::wbOptions(background = "forestgreen"))
})