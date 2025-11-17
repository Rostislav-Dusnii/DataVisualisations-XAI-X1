predict <- function(model_obj, data_h2o_test) {
  table_pred <- h2o.predict(model_obj$fit, data_h2o_test) %>%
    as.data.table() %>%
    mutate(predict = round(predict, 3)) %>%
    rename(!!model_obj$name := predict)

  return(table_pred)
}
