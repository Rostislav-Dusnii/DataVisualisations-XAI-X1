source_dir("modules/server/reactive/ml/utils")

prepare_data_for_models <- function(data, input, test_1, test_2, train_1, model) {
  req(!is.null(input$checkbox_time_series))

  strategy_fn <- get_data_strategy(input$checkbox_time_series)
  strategy_output <- strategy_fn(data, input, test_1, test_2, train_1)

  data_train <- strategy_output$data_train
  data_test <- strategy_output$data_test
  data_results <- strategy_output$data_results
  data_h2o_train <- strategy_output$data_h2o_train
  data_h2o_test <- strategy_output$data_h2o_test

  var_input_list <- model$train_variables
  if (length(var_input_list) == 0) var_input_list <- character(0)

  cat("asaaaaaaa", strategy_output$data_h2o_train, "uffff")
  list(
    data_train = data_train,
    data_test = data_test,
    data_results = data_results,
    data_h2o_train = data_h2o_train,
    data_h2o_test = data_h2o_test,
    var_input_list = var_input_list
  )
}
