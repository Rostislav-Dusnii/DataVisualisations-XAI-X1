fit_random_forest <- function(var_input_list, y, data_h2o_train, parameter) {
  model_display_name <- "Random forest"
  t1 <- Sys.time()
  fit <- h2o.randomForest(
    x = as.character(var_input_list),
    y = y,
    training_frame = data_h2o_train,
    ntrees = parameter$num_tree_random_forest,
    sample_rate = parameter$subsampling_rate_random_forest,
    max_depth = parameter$max_depth_random_forest,
    nbins = parameter$n_bins_random_forest,
    seed = 123
  )
  t2 <- Sys.time()

  time_info <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = model_display_name)

  list(fit = fit, name = model_display_name, time = time_info)
}
