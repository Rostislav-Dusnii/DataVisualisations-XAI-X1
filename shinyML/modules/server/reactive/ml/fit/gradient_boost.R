fit_gradient_boost <- function(var_input_list, y, data_h2o_train, parameter) {
  model_display_name <- "Gradient boosted trees"
  t1 <- Sys.time()

  fit <- h2o.gbm(
    x = as.character(var_input_list),
    y = y,
    training_frame = data_h2o_train,
    sample_rate = parameter$sample_rate_gbm,
    ntrees = parameter$n_trees_gbm,
    max_depth = parameter$max_depth_gbm,
    learn_rate = parameter$learn_rate_gbm,
    min_rows = 2,
    seed = 123
  )

  t2 <- Sys.time()
  time_info <- data.frame(
    `Training time` = paste0(round(t2 - t1, 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit, name = model_display_name, time = time_info)
}
