# Make neural network parameters correspond to cursors and radiobuttons choices when user click on "Run neural network regression" button (and disable other models)

observeEvent(input$run_neural_network, {
  train_1$date <- input$train_selector[1]
  test_1$date <- input$test_selector[1]
  test_2$date <- input$test_selector[2]
  model$train_variables <- input$input_variables

  v_neural$type_model <- "ml_neural_network"
  v_grad$type_model <- NA
  v_glm$type_model <- NA
  v_random$type_model <- NA
  v_auto_ml$type_model <- NA

  parameter$hidden_neural_net <- input$hidden_neural_net
  parameter$epochs_neural_net <- input$epochs_neural_net
  parameter$activation_neural_net <- input$activation_neural_net
  parameter$loss_neural_net <- input$loss_neural_net
  parameter$rate_neural_net <- input$rate_neural_net
})
