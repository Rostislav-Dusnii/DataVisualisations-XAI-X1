# trains H2O random forest
fit_random_forest_h2o <- function(y, data_train, parameter) {
  parameter$framework <- "h2o"
  model_display_name <- "Random forest"
  t1 <- Sys.time()
  fit <- h2o.randomForest(
    y = y,
    training_frame = as.h2o(data_train),
    ntrees = parameter$num_tree_random_forest,
    sample_rate = parameter$subsampling_rate_random_forest,
    max_depth = parameter$max_depth_random_forest,
    nbins = parameter$n_bins_random_forest,
    seed = 123
  )
  t2 <- Sys.time()

  time_info <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = model_display_name)

  list(fit = fit, name = model_display_name, time = time_info, params = parameter)
}
