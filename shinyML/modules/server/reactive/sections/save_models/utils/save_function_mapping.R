source("modules/server/reactive/sections/save_models/utils/save_functions.R", local = shared_env)

save_function_mapping <- list(
  mlr = save_mlr_model,
  h2o = save_h2o_model
)
