# Make glm parameters correspond to cursors and radiobuttons choices when user click on "Run generalized linear regression" button
observeEvent(input$run_glm, {
  model$train_variables <- input$input_variables
  v_grad$type_model <- NA
  v_neural$type_model <- NA
  v_random$type_model <- NA
  v_decision_tree$type_model <- NA
  v_auto_ml$type_model <- NA
  v_glm$type_model <- "ml_generalized_linear_regression"

  parameter$family_glm <- input$glm_family
  parameter$glm_link <- input$glm_link
  parameter$intercept_term_glm <- input$intercept_term_glm
  parameter$reg_param_glm <- input$reg_param_glm
  parameter$alpha_param_glm <- input$alpha_param_glm
  parameter$max_iter_glm <- input$max_iter_glm
})
