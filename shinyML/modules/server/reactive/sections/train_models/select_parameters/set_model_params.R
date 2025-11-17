set_model_params <- function(is_selected, model_name, param_map) {
  if (isFALSE(is_selected)) {
    models_to_train$params[[model_name]] <- NULL
    return(NULL)
  }
  # Build params from input IDs
  params <- lapply(param_map, function(input_name) input[[input_name]])
  names(params) <- names(param_map)

  # Store in models_to_train
  models_to_train$params[[model_name]] <- params
}
