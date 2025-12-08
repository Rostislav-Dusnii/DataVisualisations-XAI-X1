models_to_train <- reactiveValues(params = list())
source("modules/server/reactive/sections/train_models/select_parameters/select_buttons_events.R", local = shared_env)
source_dir("modules/server/reactive/sections/train_models/ml", local = shared_env)

split <- list(train = 70)
train_test_data <- reactive({
  prepare_data_for_models(data, split)
})

all_training_results <- reactiveVal(list(
  trained_models = list(),
  table_training_time = data.table(),
  table_importance = data.table()
))

observeEvent(input$train_models_btn, {
  prep_data <- train_test_data()

  train_results <- train_models(
    prep_data,
    features$list,
    target$value,
    models_to_train$params
  )

  current_results <- all_training_results()
  combined_models <- c(current_results$trained_models, train_results$trained_models)
  combined_times <- rbind(current_results$table_training_time, train_results$table_training_time)
  combined_importance <- rbind(current_results$table_importance, train_results$table_importance)

  # Update the stored results
  all_training_results(list(
    trained_models = combined_models,
    table_training_time = combined_times,
    table_importance = combined_importance
  ))
})

model_training_results <- reactive({
  all_training_results()
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

active_model <- reactive({
  tm <- model_training_results()[["trained_models"]]
  if (length(tm) == 0) {
    return(NULL)
  }

  selected_idx <- input$selected_model
  if (!is.null(selected_idx) && selected_idx >= 1 && selected_idx <= length(tm)) {
    return(tm[[as.integer(selected_idx)]])
  }

  tm[[1]]
})

xai_payload <- reactive({
  model_obj <- active_model()
  req(model_obj)

  y_col <- target$value
  data_test <- train_test_data()[["data_test"]]
  req(!is.null(data_test), y_col %in% names(data_test))

  x_test <- data_test[, setdiff(names(data_test), y_col), drop = FALSE]
  y_test <- data_test[[y_col]]

  predict_fun <- NULL
  framework <- model_obj$params$framework
  if (!is.null(framework) && length(framework) > 0) {
    if (framework == "h2o") {
      predict_fun <- function(m, newdata) {
        as.vector(h2o.predict(m, as.h2o(newdata))$predict)
      }
    } else if (framework == "mlr") {
      predict_fun <- function(m, newdata) {
        predict(m, newdata = newdata)$data$response
      }
    }
  }

  explainer <- DALEX::explain(
    model = model_obj$fit,
    data = x_test,
    y = y_test,
    label = model_obj$name,
    predict_function = predict_fun,
    verbose = FALSE
  )

  new_obs <- head(data_test, 2)

  # Return explainer for arena.drwhy integration
  list(
    model_label = model_obj$name,
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
