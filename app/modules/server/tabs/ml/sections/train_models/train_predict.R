models_to_train <- reactiveValues(params = list())
source(path(PATH_SELECT_PARAMS,"select_buttons_events.R"), local = shared_env)
source_dir(PATH_TRAIN_ML, local = shared_env)

observeEvent(input$train_models_btn, {
  prep_data <- train_test_data()

  train_results <- train_models(
    prep_data,
    target$value,
    models_to_train$params
  )

  # Get current accumulated results
  current_results <- all_training_results()

  # Combine new models with existing ones
  combined_models <- c(current_results$trained_models, train_results$trained_models)

  # Combine training times
  combined_times <- rbind(current_results$table_training_time, train_results$table_training_time)

  # Combine feature importances
  combined_importance <- rbind(current_results$table_importance, train_results$table_importance)

  # Update the stored results
  all_training_results(list(
    trained_models = combined_models,
    table_training_time = combined_times,
    table_importance = combined_importance
  ))
})

predictions <- reactive({
  prep_data <- train_test_data()
  trained_models <- model_training_results()$trained_models
  table_results <- make_predict_tables(
    trained_models,
    prep_data,
    target
  )
  list(table_results = table_results)
})

