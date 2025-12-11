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