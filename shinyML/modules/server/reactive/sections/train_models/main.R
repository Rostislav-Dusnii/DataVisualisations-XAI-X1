models_to_train <- reactiveValues(params = list())
source("modules/server/reactive/sections/train_models/select_parameters/select_buttons_events.R", local = shared_env)
source_dir("modules/server/reactive/sections/train_models/ml", local = shared_env)

split <- list(train = 70)
train_test_data <- reactive({
  prepare_data_for_models(current_dataset$data, split)
})

model_training_results <- eventReactive(input$train_models_btn, {
  prep_data <- train_test_data()

  train_results <- train_models(
    prep_data,
    features$list,
    target$value,
    models_to_train$params
  )
  train_results
})

predictions <- reactive({
  prep_data <- train_test_data()
  trained_models <- model_training_results()$trained_models
  table_results <- make_predictions(
    trained_models,
    prep_data,
    target
  )
  list(table_results = table_results)
})
