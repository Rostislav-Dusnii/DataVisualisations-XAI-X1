models_to_train <- reactiveValues(params = list())
source("modules/server/reactive/sections/train_models/select_parameters/select_buttons_events.R", local = shared_env)
source_dir("modules/server/reactive/sections/train_models/ml", local = shared_env)

split <- list(train = 70)
train_test_data <- reactive({
  prepare_data_for_models(data, split)
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
    prep_data
  )
  list(table_results = table_results)
})

# pick an active model (first trained by default)
active_model <- reactive({
  tm <- model_training_results()[["trained_models"]]
  if (length(tm) == 0) {
    return(NULL)
  }
  tm[[1]]
})

# build DALEX explainer and ModelStudio payload for the active model
xai_payload <- reactive({
  model_obj <- active_model()
  req(model_obj)

  y_col <- target$value
  data_test <- train_test_data()[["data_test"]]
  req(!is.null(data_test), y_col %in% names(data_test))

  x_test <- data_test[, setdiff(names(data_test), y_col), drop = FALSE]
  y_test <- data_test[[y_col]]

  predict_fun <- NULL
  if (identical(model_obj$params$framework, "h2o")) {
    predict_fun <- function(m, newdata) {
      as.vector(h2o.predict(m, as.h2o(newdata))$predict)
    }
  } else if (identical(model_obj$params$framework, "mlr")) {
    predict_fun <- function(m, newdata) {
      predict(m, newdata = newdata)$data$response
    }
  }

  explainer <- DALEX::explain(
    model = model_obj$fit,
    data = x_test,
    y = y_test,
    label = model_obj$name,
    predict_function = predict_fun
  )

  new_obs <- head(data_test, 2)
  ms <- modelStudio::modelStudio(explainer, new_obs)

  list(
    model_label = model_obj$name,
    arena_json = ms$x,
    explainer = explainer,
    new_obs = new_obs,
    target = y_col
  )
})

# lightweight model context for downstream consumers (e.g., chatbot)
model_context <- reactive({
  am <- active_model()
  dt <- train_test_data()
  req(am, dt)
  list(
    dataset = "user-uploaded",
    target = target$value,
    model_type = am$name,
    features = paste(setdiff(names(dt[["data_test"]]), target$value), collapse = ", "),
    n_train = nrow(dt[["data_train"]]),
    n_test = nrow(dt[["data_test"]]),
    observations_explained = min(2, nrow(dt[["data_test"]]))
  )
})
