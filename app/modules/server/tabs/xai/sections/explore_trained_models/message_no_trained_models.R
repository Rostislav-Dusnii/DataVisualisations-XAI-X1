output$message_no_trained_models <- renderUI({
  trained_models <- model_training_results()$trained_models
  if (length(trained_models) <= 0) {
    argonH1("Please train at least one model on \"Train Models\" page!", display = 4)
  }
})