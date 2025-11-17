fit_neural_network <- function(var_input_list, y, data_h2o_train, parameter) {
  model_display_name <- "Neural network"
  t1 <- Sys.time()
  fit <- h2o.deeplearning(
    x = as.character(var_input_list),
    y = y,
    training_frame = data_h2o_train,
    activation = parameter$activation_neural_net,
    loss = parameter$loss_neural_net,
    hidden = eval(parse(text = parameter$hidden_neural_net)),
    epochs = parameter$epochs_neural_net,
    rate = parameter$rate_neural_net,
    reproducible = T,
    seed = 123
  )
  t2 <- Sys.time()

  time_info <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = model_display_name)

  list(fit = fit, name = model_display_name, time = time_info)
}
