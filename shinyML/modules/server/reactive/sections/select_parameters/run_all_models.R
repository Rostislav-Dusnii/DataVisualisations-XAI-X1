# Make all parameters correspond to cursors and radiobuttons choices when user click on "Run tuned models!" button
observeEvent(input$train_all, {
  train_1$date <- input$train_selector[1]
  test_1$date <- input$test_selector[1]
  test_2$date <- input$test_selector[2]

  model$train_variables <- input$input_variables

  v_neural$type_model <- "ml_neural_network"
  v_grad$type_model <- "ml_gradient_boosted_trees"
  v_glm$type_model <- "ml_generalized_linear_regression"
  v_random$type_model <- "ml_random_forest"
  v_auto_ml$type_model <- NA

  parameter$family_glm <- input$glm_family
  parameter$glm_link <- input$glm_link
  parameter$intercept_term_glm <- input$intercept_term_glm
  parameter$reg_param_glm <- input$reg_param_glm
  parameter$alpha_param_glm <- input$alpha_param_glm
  parameter$max_iter_glm <- input$max_iter_glm


  parameter$num_tree_random_forest <- input$num_tree_random_forest
  parameter$subsampling_rate_random_forest <- input$subsampling_rate_random_forest
  parameter$max_depth_random_forest <- input$max_depth_random_forest
  parameter$n_bins_random_forest <- input$n_bins_random_forest

  parameter$sample_rate_gbm <- input$sample_rate_gbm
  parameter$n_trees_gbm <- input$n_trees_gbm
  parameter$max_depth_gbm <- input$max_depth_gbm
  parameter$learn_rate_gbm <- input$learn_rate_gbm

  parameter$hidden_neural_net <- input$hidden_neural_net
  parameter$epochs_neural_net <- input$epochs_neural_net
  parameter$activation_neural_net <- input$activation_neural_net
  parameter$loss_neural_net <- input$loss_neural_net
  parameter$rate_neural_net <- input$rate_neural_net
})

# When "Run all models!" button is clicked, send messageBox once all models have been trained
observe({
  if (ncol(table_forecast()[["results"]]) == ncol(data) + 4) {
    sendSweetAlert(
      session = session,
      title = "The four machine learning models have been trained !",
      text = "Click ok to see results",
      type = "success"
    )
  }
})
