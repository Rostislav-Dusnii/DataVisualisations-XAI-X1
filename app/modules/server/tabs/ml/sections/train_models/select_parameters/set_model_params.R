# stores or clears model params based on checkbox state
set_model_params <- function(is_selected, model_name, param_map) {
  if (isFALSE(is_selected)) {
    models_to_train$params[[model_name]] <- NULL
    return(NULL)
  }

  params <- lapply(param_map, function(input_name) input[[input_name]])
  names(params) <- names(param_map)
  models_to_train$params[[model_name]] <- params
}
