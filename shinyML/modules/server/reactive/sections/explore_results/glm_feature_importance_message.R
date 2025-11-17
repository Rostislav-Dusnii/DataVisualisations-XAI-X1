# Message indicating that feature importance is not available for glm model
output$glm_feature_importance_message <- renderUI({
  # Get trained models AFTER clicking "Train models"
  trained <- model_training_results()$trained_models

  # If nothing trained yet → show nothing
  if (is.null(trained) || length(trained) == 0) {
    return(NULL)
  }

  # GLM selected?
  glm_selected <- "glm" %in% names(trained)

  if (glm_selected) {
    argonH1("Feature importance not available for generalized regression method", display = 4)
  }
})
