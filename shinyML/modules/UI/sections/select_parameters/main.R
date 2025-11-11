source_dir("modules/UI/sections/select_parameters/cards")

models_actions <- argonRow(
  generalized_linear_regression,
  random_forest,
  neural_network,
  gradient_boosting
)

groupped_actions <- argonRow(
  all_models,
  auto_ml
)
