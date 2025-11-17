source("modules/server/reactive/sections/train_models/ml/utils/get_data_split_strategy.R", local = shared_env)

prepare_data_for_models <- function(data, split) {
  split_function <- get_data_split_strategy()
  split <- list(train = 70)
  split_output <- split_function(data, split)

  data_train <- split_output$data_train
  data_test <- split_output$data_test
  data_h2o_train <- split_output$data_h2o_train
  data_h2o_test <- split_output$data_h2o_test

  list(
    data_train = data_train,
    data_test = data_test,
    data_h2o_train = data_h2o_train,
    data_h2o_test = data_h2o_test
  )
}
