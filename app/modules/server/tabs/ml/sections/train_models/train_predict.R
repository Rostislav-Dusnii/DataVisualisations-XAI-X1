models_to_train <- reactiveValues(params = list())
source(path(PATH_SELECT_PARAMS,"select_buttons_events.R"), local = shared_env)
source_dir(PATH_TRAIN_ML, local = shared_env)

observeEvent(input$train_models_btn, {
  prep_data <- train_test_data()
  train_results <- train_models(
    prep_data,
    target,
    models_to_train$params
  )

  # Combine new models with existing ones
  combined_models <- train_results$trained_models

  # Combine training times
  combined_times <- train_results$table_training_time

  # Combine feature importances
  combined_importance <- train_results$table_importance

  # Update the stored results
  all_training_results(list(
    trained_models = combined_models,
    table_training_time = combined_times,
    table_importance = combined_importance
  ))
})

predictions <- eventReactive(model_training_results()$trained_models, {
  trained_models <- model_training_results()$trained_models
  req(trained_models)
  req(length(trained_models) > 0)

  prep_data <- train_test_data()
  target_obj <- reactiveValuesToList(target)

  table_results <- make_predict_tables(trained_models, prep_data, target_obj)
  list(table_results = table_results)
})

