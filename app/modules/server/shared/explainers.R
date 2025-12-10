source(path(PATH_SHARED_UTILS,"explain.R"), local = shared_env)

explainers <- reactive({
  dt <- train_test_data()
  y_col <- target$value
  training_results <- model_training_results()[["trained_models"]]

  req(dt, y_col, length(training_results) > 0)
  req(y_col %in% names(dt$data_test_encoded))
  data_test <- dt$data_test_encoded
  data_y <- data_test[[y_col]]

  # ---- Create explainers for all trained models ----
  explainer_list <- lapply(training_results, function(model_obj) {

    explain_fun <- explain_function_mapping[[model_obj$params$framework]]

    explainer <- explain_fun(model_obj, data_test, data_y)

    explainer
  })

  explainer_list
})
