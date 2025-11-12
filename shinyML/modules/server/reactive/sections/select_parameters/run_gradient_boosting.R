# Make gradient boosting parameters correspond to cursors when user click on "Run gradient boosting model" button (and disable other models)
observeEvent(input$run_gradient_boosting, {
  train_1$date <- input$train_selector[1]
  test_1$date <- input$test_selector[1]
  test_2$date <- input$test_selector[2]
  model$train_variables <- input$input_variables
  v_grad$type_model <- "ml_gradient_boosted_trees"
  v_neural$type_model <- NA
  v_glm$type_model <- NA
  v_random$type_model <- NA
  v_auto_ml$type_model <- NA
  v_decision_tree$type_model <- NA


  parameter$sample_rate_gbm <- input$sample_rate_gbm
  parameter$n_trees_gbm <- input$n_trees_gbm
  parameter$max_depth_gbm <- input$max_depth_gbm
  parameter$learn_rate_gbm <- input$learn_rate_gbm
  parameter$step_size_gbm <- input$step_size_gbm
  parameter$subsampling_rate_gbm <- input$subsampling_rate_gbm
})
