source(path(PATH_SELECT_PARAMS,"models_parameters_maps.R"), local = shared_env)
source(path(PATH_SELECT_PARAMS,"set_model_params.R"), local = shared_env)

observeEvent(input$select_rf_h2o, {
  set_model_params(input$select_rf_h2o, "rf_h2o", rf_h2o_param_map)
})

observeEvent(input$select_nn_h2o, {
  set_model_params(input$select_nn_h2o, "nn_h2o", nn_h2o_param_map)
})

observeEvent(input$select_gb_h2o, {
  set_model_params(input$select_gb_h2o, "gb_h2o", gb_h2o_param_map)
})

observeEvent(input$select_glm_h2o, {
  set_model_params(input$select_glm_h2o, "glm_h2o", glm_h2o_param_map)
})

observeEvent(input$select_ranger_mlr, {
  set_model_params(input$select_ranger_mlr, "ranger_mlr", ranger_mlr_param_map)
})
