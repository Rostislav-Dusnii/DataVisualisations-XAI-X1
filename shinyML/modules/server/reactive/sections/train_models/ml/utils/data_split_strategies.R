split_default_data <- function(data, split) {
  data_train <- data %>% sample_frac(split$train * 0.01)
  data_test <- data %>% anti_join(data_train, by = available_variables)

  list(
    data_train = data_train,
    data_test = data_test,
    data_h2o_train = as.h2o(data_train),
    data_h2o_test = as.h2o(data_test)
  )
}
