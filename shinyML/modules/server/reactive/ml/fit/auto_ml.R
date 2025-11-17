fit_auto_ml <- function(var_input_list, y, data_h2o_train, parameter) {
  req(!is.null(parameter$auto_ml_autorized_models))

  model_display_name <- "Auto ML"
  t1 <- Sys.time()

  fit <- h2o.automl(
    x = as.character(var_input_list),
    include_algos = parameter$auto_ml_autorized_models,
    y = y,
    training_frame = data_h2o_train,
    max_runtime_secs = parameter$run_time_auto_ml,
    seed = 123
  )

  t2 <- Sys.time()
  time_info <- data.frame(
    `Training time` = paste0(round(t2 - t1, 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit@leader, name = model_display_name, time = time_info)
}
