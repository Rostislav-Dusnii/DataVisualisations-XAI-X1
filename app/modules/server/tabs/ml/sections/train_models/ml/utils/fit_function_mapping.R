source_dir(PATH_TRAIN_FIT_H2O, local = shared_env)
source_dir(PATH_TRAIN_FIT_MLR, local = shared_env)

# maps model names to their training functions
fit_function_mapping <- list(
  glm_h2o = fit_glm_h2o,
  rf_h2o = fit_random_forest_h2o,
  nn_h2o = fit_neural_network_h2o,
  gb_h2o = fit_gradient_boost_h2o,
  ranger_mlr = fit_ranger_mlr
)
