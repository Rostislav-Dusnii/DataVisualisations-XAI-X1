# Make random forest parameters correspond to cursors when user click on "Run random forest model" button (and disable other models)
observeEvent(input$run_random_forest, {
  train_1$date <- input$train_selector[1]
  test_1$date <- input$test_selector[1]
  test_2$date <- input$test_selector[2]
  model$train_variables <- input$input_variables
  v_grad$type_model <- NA
  v_neural$type_model <- NA
  v_glm$type_model <- NA
  v_auto_ml$type_model <- NA
  v_decision_tree$type_model <- NA
  v_random$type_model <- "ml_random_forest"

  parameter$num_tree_random_forest <- input$num_tree_random_forest
  parameter$subsampling_rate_random_forest <- input$subsampling_rate_random_forest
  parameter$max_depth_random_forest <- input$max_depth_random_forest
  parameter$n_bins_random_forest <- input$n_bins_random_forest
})
