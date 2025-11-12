observeEvent(input$save_models, {
  # Ensure table_forecast() exists
  req(table_forecast())

  # Create folder to save models if it doesn't exist
  if (!dir.exists("saved_models")) dir.create("saved_models")
  # Save GLM model if it exists
  if (!is.null(v_glm$type_model) && v_glm$type_model == "ml_generalized_linear_regression") {
    h2o.saveModel(trained_models$glm, path = "saved_models/glm", force = TRUE)
  }

  # Save Random Forest model if it exists
  if (!is.null(v_random$type_model) && v_random$type_model == "ml_random_forest") {
    h2o.saveModel(trained_models$randomForest, path = "saved_models/random_forest", force = TRUE)
  }

  # Save Neural Network model if it exists
  if (!is.null(v_neural$type_model) && v_neural$type_model == "ml_neural_network") {
    h2o.saveModel(trained_models$neuralNet, path = "saved_models/neural_network", force = TRUE)
  }

  # Save Gradient Boosted Trees model if it exists
  if (!is.null(v_grad$type_model) && v_grad$type_model == "ml_gradient_boosted_trees") {
    h2o.saveModel(trained_models$gradientBoost, path = "saved_models/gbm", force = TRUE)
  }
  showNotification("Models saved successfully!", type = "message", duration = 5)
})
