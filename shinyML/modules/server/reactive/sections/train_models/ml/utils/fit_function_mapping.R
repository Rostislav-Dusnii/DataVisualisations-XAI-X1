source_dir("modules/server/reactive/sections/train_models/ml/utils/fit/h2o", local = shared_env)
source_dir("modules/server/reactive/sections/train_models/ml/utils/fit/mlr", local = shared_env)

fit_function_mapping <- list(
  glm_h2o = fit_glm_h2o,
  rf_h2o = fit_random_forest_h2o,
  nn_h2o = fit_neural_network_h2o,
  gb_h2o = fit_gradient_boost_h2o,
  ranger_mlr = fit_ranger_mlr
)
