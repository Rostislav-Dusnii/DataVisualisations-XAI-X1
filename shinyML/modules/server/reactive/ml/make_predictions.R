source_dir("modules/server/reactive/ml/utils")

make_predictions <- function(trained_models, prep_data) {
  all_results <- list()

  for (model_obj in trained_models) {
    all_results[[model_obj$name]] <- predict(model_obj, prep_data$data_h2o_test)
  }

  all_results_unnamed <- unname(all_results)
  cat("saa", prep_data$data_h2o_test, "asas")
  table_results <- cbind(prep_data$data_test, do.call(cbind, all_results_unnamed))

  table_results
}
