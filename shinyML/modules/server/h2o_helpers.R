prepare_h2o_data <- function(data, train_idx, test_idx, exclude_cols = NULL) {
  train_data <- data[train_idx, , drop = FALSE]
  test_data <- data[test_idx, , drop = FALSE]

  if (!is.null(exclude_cols)) {
    train_data[, (exclude_cols) := NULL]
    test_data[, (exclude_cols) := NULL]
  }

  list(
    train = as.h2o(train_data),
    test = as.h2o(test_data)
  )
}

train_h2o_model <- function(model_type, x, y, train_data, test_data, params) {
  t1 <- Sys.time()
  fit <- switch(model_type,
    glm = h2o.glm(x = x, y = y, training_frame = train_data, !!!params),
    random_forest = h2o.randomForest(x = x, y = y, training_frame = train_data, !!!params),
    neural_net = h2o.deeplearning(x = x, y = y, training_frame = train_data, !!!params),
    gbm = h2o.gbm(x = x, y = y, training_frame = train_data, !!!params),
    automl = h2o.automl(x = x, y = y, training_frame = train_data, !!!params)
  )
  t2 <- Sys.time()
  time <- round(difftime(t2, t1, units = "secs"), 1)

  preds <- h2o.predict(fit, test_data) %>%
    as.data.table() %>%
    mutate(predict = round(predict, 3))

  importance <- if (model_type %in% c("random_forest", "neural_net", "gbm")) {
    h2o.varimp(fit) %>%
      as.data.table() %>%
      select(variable, scaled_importance) %>%
      mutate(model = model_type)
  } else {
    NULL
  }

  list(fit = fit, time = time, predictions = preds, importance = importance)
}
