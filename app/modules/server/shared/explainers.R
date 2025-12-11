source(path(PATH_SHARED_UTILS, "explain.R"), local = shared_env)

explainers <- reactive({

  training_results <- model_training_results()[["trained_models"]]

  req(length(training_results) > 0)

  dt     <- isolate(train_test_data())
  y_col  <- isolate(target$value)

  req(dt, y_col)
  req(y_col %in% names(dt$data_test_encoded))

  data_test <- isolate(dt$data_test_encoded)
  data_y    <- isolate(data_test[[y_col]])

  lapply(training_results, function(model_obj) {

    explain_fun <- explain_function_mapping[[model_obj$params$framework]]
    explain_fun(model_obj, data_test, data_y)

  })
})
