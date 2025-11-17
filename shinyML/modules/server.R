create_shinyML_Server <- function(data, y) {
  source("modules/helpers.R")
  source_dir("modules/server")

  res <- process_input_data(data, y)
  data <- res$data
  y <- res$y
  x <- res$x

  # Initialize all reactive variables
  model <- reactiveValues()
  train_1 <- reactiveValues()
  test_1 <- reactiveValues()
  test_2 <- reactiveValues()
  v_neural <- reactiveValues(type_model = NA)
  v_grad <- reactiveValues(type_model = NA)
  v_glm <- reactiveValues(type_model = NA)
  v_decision_tree <- reactiveValues(type_model = NA)
  v_random <- reactiveValues(type_model = NA)
  v_auto_ml <- reactiveValues(type_model = NA)
  parameter <- reactiveValues()

  # Initialize scalar values
  scaled_importance <- NULL
  variable <- NULL
  Predicted_value <- NULL
  Model <- NULL
  `.` <- NULL
  `MAPE(%)` <- NULL
  Counter <- NULL
  feature <- NULL
  importance <- NULL
  fit <- NULL
  prediction <- NULL
  `..density..` <- NULL

  server <- function(session, input, output) {
    shared_env <- list2env(list(
      input = input,
      output = output
    ))

    # Build vector resuming which Date or POSIXct columns are contained in input dataset
    dates_variable_list <- reactive({
      req(data) # ensure data is available
      get_date_columns(data)
    })

    source_dir("modules/server/reactive/sections", local = shared_env)
    source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/select_parameters", local = shared_env)
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
    source_dir("modules/server/reactive/ml")


    train_test_data <- reactive({
      prepare_data_for_models(data, input, test_1, test_2, train_1, model)
    })

    model_training_results <- reactive({
      prep_data <- train_test_data()
      selected_models <- c(
        v_glm$type_model,
        v_random$type_model,
        v_neural$type_model,
        v_grad$type_model,
        v_auto_ml$type_model
      )
      train_results <- train_models(
        prep_data,
        selected_models,
        y,
        parameter
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
      table_results
    })
  }

  list(server = server)
}
