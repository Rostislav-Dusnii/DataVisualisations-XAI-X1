# badge showing train/test split ratio
output$message_train_test_split <- renderUI({
  argonBadge(text = HTML(paste0(
    "<big><big>Train/Test split:<b>",
    "</b> 70%</big></big>"
  )), status = "info")
})
