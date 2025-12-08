predict_h2o <- function(model_obj, data_test) {
  table_pred <- h2o.predict(model_obj$fit, as.h2o(data_test)) %>%
    as.data.table() %>%
    mutate(predict = round(predict, 3)) %>%
    rename(!!model_obj$name := predict)

  table_pred
}

predict_mlr <- function(model_obj, data_test) {
  preds <- predict(model_obj$fit, newdata = data_test)
  print(preds)
  print(preds$data)
  table_pred <- preds$data %>% 
    as.data.table() %>%
    mutate(response = round(response, 3)) %>%
    select(-truth) %>%
    rename(!!model_obj$name := response)

  table_pred
}

predict_function_mapping <- list(
  h2o = predict_h2o,
  mlr = predict_mlr
)
