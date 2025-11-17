source_dir("modules/server/reactive/ml/utils")

train_models <- function(prep_data, var_input_list, selected_models, y, parameter) {
  trained_models <- list()
  all_times <- list()
  all_importances <- list()

  # Filter out NA models
  selected_models <- selected_models[!is.na(selected_models)]
  selected_fit_functions <- fit_function_mapping[selected_models]

  if (length(var_input_list) == 0) {
    return(
      list(
        trained_models = trained_models,
        table_training_time = data.table(),
        table_importance = data.table()
      )
    )
  }

  for (model_name in names(selected_fit_functions)) {
    fit_fn <- selected_fit_functions[[model_name]]

    # Fit the model
    model_obj <- fit_fn(var_input_list, y, prep_data$data_h2o_train, parameter)

    # Store model, time, importance, and predictions
    trained_models[[model_name]] <- model_obj
    all_times[[model_name]] <- model_obj$time
    feature_importance <- get_feature_importance(model_obj)
    if (!is.null(feature_importance)) {
      all_importances[[model_name]] <- feature_importance
    }
  }
  table_training_time <- do.call(rbind, all_times)
  table_importance <- if (length(all_importances) > 0) do.call(rbind, all_importances) else data.table()

  list(
    trained_models = trained_models,
    table_training_time = table_training_time,
    table_importance = table_importance
  )
}
