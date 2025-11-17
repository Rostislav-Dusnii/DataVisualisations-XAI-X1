# Define importance features table table visible on "Feature importance" tab
output$feature_importance <- renderPlotly({
  if (nrow(model_training_results()[["table_importance"]]) != 0) {
    ggplotly(
      ggplot(data = model_training_results()[["table_importance"]]) +
        geom_bar(aes(x = reorder(`variable`, scaled_importance), y = scaled_importance, fill = `model`), stat = "identity", width = 0.3) +
        facet_wrap(model ~ .) +
        coord_flip() +
        xlab("") +
        ylab("") +
        theme(legend.position = "none")
    )
  }
})


# Message indicating that results are not available if no model has been running
output$message_feature_importance <- renderUI({
  if (ncol(predictions()[["table_results"]]) <= ncol(data)) {
    sendSweetAlert(
      session = session,
      title = "",
      text = "Please run at least one algorithm to check features importances !",
      type = "error"
    )

    argonH1("Please run at least one algorithm to check features importances !", display = 4)
  }
})
