source_dir("modules/server/reactive/sections/train_models/ml/utils/fit", local = shared_env)

fit_function_mapping <- list(
  glm = fit_glm,
  rf = fit_random_forest,
  nn = fit_neural_network,
  gb = fit_gradient_boost
)
