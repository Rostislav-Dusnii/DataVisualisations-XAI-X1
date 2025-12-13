# random train/test split
split_default_data <- function(data, split) {
  index <- sample(seq_len(nrow(data)), split$train * 0.01 * nrow(data))
  train <- data[index, ]
  test <- data[-index, ]

  list(
    data_train = train,
    data_test = test
  )
}

# prepares dataset for model training with encoding
prepare_data_for_models <- function(
  data,
  split = list(train = 70),
  target_col = NULL,
  selected_features = list(),
  session = shiny::getDefaultReactiveDomain()
) {

  # split train/test
  split_output <- split_default_data(data, split)
  data_train <- data.table::as.data.table(split_output$data_train)
  data_test  <- data.table::as.data.table(split_output$data_test)

  # convert non-numeric to factors
  for (col in colnames(data_train)) {
    if (!is.numeric(data_train[[col]]) && !is.integer(data_train[[col]])) {
      data_train[[col]] <- as.factor(data_train[[col]])
      data_test[[col]]  <- as.factor(data_test[[col]])
    }
  }

  # apply feature selection
  if (length(selected_features) > 0) {
    keep_cols <- c(selected_features, target_col)
    keep_cols <- keep_cols[keep_cols %in% colnames(data_train)]

    data_train <- data_train[, keep_cols, with = FALSE]
    data_test  <- data_test[, keep_cols, with = FALSE]
  }

  # one-hot encode for model training
  if (!is.na(target_col) && !is.null(target_col)) {
    y_train <- data_train[[target_col]]
    x_train <- data_train[, setdiff(colnames(data_train), target_col), with = FALSE]
    x_train_mm <- model.matrix(~ . -1, data = x_train)
    data_train_encoded <- as.data.table(x_train_mm)
    data_train_encoded[[target_col]] <- y_train

    y_test <- data_test[[target_col]]
    x_test <- data_test[, setdiff(colnames(data_test), target_col), with = FALSE]
    x_test_mm <- model.matrix(~ . -1, data = x_test)
    data_test_encoded <- as.data.table(x_test_mm)
    data_test_encoded[[target_col]] <- y_test

  } else {
    data_train_encoded <- as.data.table(model.matrix(~ . -1, data = data_train))
    data_test_encoded  <- as.data.table(model.matrix(~ . -1, data = data_test))
  }

  list(
    data_train = as.data.frame(data_train),
    data_test = as.data.frame(data_test),
    data_train_encoded = as.data.frame(data_train_encoded),
    data_test_encoded = as.data.frame(data_test_encoded)
  )
}