source("modules/server/reactive/sections/train_models/ml/utils/predict.R", local = shared_env)

make_predictions <- function(trained_models, prep_data, target) {
  all_results <- list()

  for (model_obj in trained_models) {
    predict_func <- predict_function_mapping[[model_obj$params$framework]]
    all_results[[model_obj$name]] <- predict_func(model_obj, prep_data$data_test)
  }

  all_results_unnamed <- unname(all_results)
  table_results <- cbind(prep_data$data_test, do.call(cbind, all_results_unnamed)) %>%
    as.data.table() %>%
    rename(!!target$results_table_value := target$value)

  table_results
}
