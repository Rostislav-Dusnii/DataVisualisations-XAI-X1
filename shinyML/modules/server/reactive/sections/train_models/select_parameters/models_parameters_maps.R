rf_h2o_param_map <- list(
  num_tree_random_forest = "num_tree_random_forest",
  subsampling_rate_random_forest = "subsampling_rate_random_forest",
  max_depth_random_forest = "max_depth_random_forest",
  n_bins_random_forest = "n_bins_random_forest"
)

nn_h2o_param_map <- list(
  hidden_neural_net = "hidden_neural_net",
  epochs_neural_net = "epochs_neural_net",
  activation_neural_net = "activation_neural_net",
  loss_neural_net = "loss_neural_net",
  rate_neural_net = "rate_neural_net"
)

gb_h2o_param_map <- list(
  sample_rate_gbm = "sample_rate_gbm",
  n_trees_gbm = "n_trees_gbm",
  max_depth_gbm = "max_depth_gbm",
  learn_rate_gbm = "learn_rate_gbm",
  step_size_gbm = "step_size_gbm",
  subsampling_rate_gbm = "subsampling_rate_gbm"
)

glm_h2o_param_map <- list(
  family_glm = "glm_family",
  glm_link = "glm_link",
  intercept_term_glm = "intercept_term_glm",
  reg_param_glm = "reg_param_glm",
  alpha_param_glm = "alpha_param_glm",
  max_iter_glm = "max_iter_glm"
)

ranger_mlr_param_map <- list()
