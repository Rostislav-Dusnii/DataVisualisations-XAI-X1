# Make autoML parameter correspond to knobInput when user click on "Run Auto ML" button
observeEvent(input$run_auto_ml, {
  train_1$date <- input$train_selector[1]
  test_1$date <- input$test_selector[1]
  test_2$date <- input$test_selector[2]
  model$train_variables <- input$input_variables

  v_grad$type_model <- NA
  v_neural$type_model <- NA
  v_glm$type_model <- NA
  v_random$type_model <- NA
  v_auto_ml$type_model <- "ml_auto"

  parameter$run_time_auto_ml <- input$run_time_auto_ml
  parameter$auto_ml_autorized_models <- input$auto_ml_autorized_models
})


# When "Run auto ML" button is clicked, send messageBox once searching time is reached
observe({
  results <- model_training_results()
  trained <- results$trained_models
  auto_ml_name <- "ml_auto"
  if (!(auto_ml_name %in% names(trained))) {
    return(NULL)
  }
  auto_ml_model_obj <- trained[[auto_ml_name]]
  summary_df <- auto_ml_model_obj$fit$model_summary
  output_list <- list(
    HTML(paste0("<b>Selected model:</b> ", leader@algorithm))
  )
  for (i in seq_len(ncol(summary_df))) {
    col_name <- colnames(summary_df)[i]
    col_value <- summary_df[1, i] # usually AutoML summaries are one-row
    output_list <- append(
      output_list,
      list(HTML(paste0("<b>", col_name, ":</b> ", col_value)))
    )
  }

  # The message box indicates best model family and all associated hyper-parameter values
  sendSweetAlert(
    session = session,
    title = "Auto ML algorithm succeed!",
    text = HTML(paste0(
      "<br>",
      list
    )),
    type = "success",
    html = TRUE
  )
})

# Send WarningBox if Run auto ML" button is clicked and no model searching is authorized
observeEvent(input$run_auto_ml, {
  if (is.null(parameter$auto_ml_autorized_models)) {
    sendSweetAlert(
      session = session, title = "Warning !",
      text = "Please authorize at least one model family to perform auto ML",
      type = "warning"
    )
  }
})
