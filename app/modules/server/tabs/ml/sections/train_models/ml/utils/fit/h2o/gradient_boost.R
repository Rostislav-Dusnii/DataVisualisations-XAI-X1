# trains H2O gradient boosted trees
fit_gradient_boost_h2o <- function(y, data_train, parameter) {
  parameter$framework <- "h2o"
  model_display_name <- "Gradient boosted trees"
  t1 <- Sys.time()

  fit <- h2o.gbm(
    y = y,
    training_frame = as.h2o(data_train),
    sample_rate = parameter$sample_rate_gbm,
    ntrees = parameter$n_trees_gbm,
    max_depth = parameter$max_depth_gbm,
    learn_rate = parameter$learn_rate_gbm,
    min_rows = 2,
    seed = 123
  )

  t2 <- Sys.time()
  time_info <- data.frame(
    `Training time` = paste0(round(as.numeric(difftime(t2, t1, units = "secs")), 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit, name = model_display_name, time = time_info, params = parameter)
}
