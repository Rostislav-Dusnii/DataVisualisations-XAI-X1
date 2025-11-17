source("modules/server/reactive/sections/train_models/select_parameters/models_parameters_maps.R", local = shared_env)
source("modules/server/reactive/sections/train_models/select_parameters/set_model_params.R", local = shared_env)

observeEvent(input$select_rf, {
  set_model_params(input$select_rf, "rf", rf_param_map)
})

observeEvent(input$select_nn, {
  set_model_params(input$select_nn, "nn", nn_param_map)
})

observeEvent(input$select_gb, {
  set_model_params(input$select_gb, "gb", gb_param_map)
})

observeEvent(input$select_glm, {
  set_model_params(input$select_glm, "glm", glm_param_map)
})
