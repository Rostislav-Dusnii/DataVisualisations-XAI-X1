predict_h2o <- function(model_obj, data_test) {
  table_pred <- h2o.predict(model_obj$fit, as.h2o(data_test)) %>%
    as.data.table() %>%
    mutate(predict = round(predict, 3)) %>%
    rename(!!model_obj$name := predict)

  table_pred
}

predict_mlr <- function(model_obj, data_test) {
  preds <- predict(model_obj$fit, newdata = data_test)
  table_pred <- data.table(
    setNames(
      list(round(preds$data$response, 3)),
      model_obj$name
    )
  )

  table_pred
}

predict_function_mapping <- list(
  h2o = predict_h2o,
  mlr = predict_mlr
)
