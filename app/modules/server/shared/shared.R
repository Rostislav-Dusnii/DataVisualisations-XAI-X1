# Store all training results (models, times, importances) across multiple runs
all_training_results <- reactiveVal(list(
  trained_models = list(),
  table_training_time = data.table(),
  table_importance = data.table()
))


model_training_results <- reactive({
  all_training_results()
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

  data_test_df <- as.data.frame(data_test)

  x_test <- data_test_df[, setdiff(names(data_test_df), y_col), drop = FALSE]
  y_test <- data_test_df[[y_col]]

  predict_fun <- NULL
  framework <- model_obj$params$framework

  model_class <- class(model_obj$fit)[1]
  is_h2o <- grepl("^H2O", model_class)
  is_mlr <- inherits(model_obj$fit, "WrappedModel")

  if (is_h2o || (!is.null(framework) && framework == "h2o")) {
    predict_fun <- function(m, newdata) {
      preds <- h2o.predict(m, as.h2o(newdata))
      as.vector(preds$predict)
    }
  } else if (is_mlr || (!is.null(framework) && framework == "mlr")) {
    predict_fun <- function(m, newdata) {
      predict(m, newdata = newdata)$data$response
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

  new_obs <- head(data_test_df, 2)

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