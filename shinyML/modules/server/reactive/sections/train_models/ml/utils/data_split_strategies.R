split_default_data <- function(data, split) {
  index <- sample(seq_len(nrow(data)), split$train * 0.01 * nrow(data))
  train <- data[index, ]
  test <- data[-index, ]

  list(
    data_train = train,
    data_test = test
  )
}
