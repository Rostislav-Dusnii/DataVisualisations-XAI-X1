source_dir("modules/server/reactive/ml/fit")

fit_function_mapping <- list(
  ml_generalized_linear_regression = fit_glm,
  ml_random_forest = fit_random_forest,
  ml_neural_network = fit_neural_network,
  ml_gradient_boosted_trees = fit_gradient_boost,
  ml_auto = fit_auto_ml
)
