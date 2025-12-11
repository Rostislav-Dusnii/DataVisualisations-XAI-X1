source(path(PATH_TRAIN_UTILS,"predict_table.R"), local = shared_env)

make_predict_tables <- function(trained_models, prep_data, target_obj) {
  all_results <- list()
  req(target$results_table_value)
  req(target$value)

  for (model_obj in trained_models) {
    predict_table_func <- predict_table_function_mapping[[model_obj$params$framework]]
    all_results[[model_obj$name]] <- predict_table_func(model_obj, prep_data$data_test_encoded)
  }

  all_results_unnamed <- unname(all_results)
  table_results <- cbind(as.data.table(prep_data$data_test), do.call(cbind, all_results_unnamed)) %>%
    as.data.table() %>%
    rename(!!target$results_table_value := target$value)

  table_results
}
