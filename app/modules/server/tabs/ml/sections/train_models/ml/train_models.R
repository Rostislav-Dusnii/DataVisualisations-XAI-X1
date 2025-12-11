source(path(PATH_TRAIN_UTILS,"fit_function_mapping.R"), local = shared_env)
source(path(PATH_TRAIN_UTILS,"get_feature_importance.R"), local = shared_env)

train_models <- function(prep_data, y, models_to_train) {
  trained_models <- list()
  all_times <- list()
  all_importances <- list()

  if (length(features$list) == 0 || length(models_to_train) == 0 || is.null(target$value)) {
    return(
      list(
        trained_models = trained_models,
        table_training_time = data.table(),
        table_importance = data.table()
      )
    )
  }
  selected_fit_functions <- fit_function_mapping[names(models_to_train)]


  for (model_name in names(selected_fit_functions)) {
    fit_fn <- selected_fit_functions[[model_name]]
    parameter <- models_to_train[[model_name]]
    # Fit the model
    model_obj <- fit_fn(y$value, prep_data$data_train_encoded, parameter)
    model_obj$prep_data <- prep_data
    model_obj$target <- y

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
