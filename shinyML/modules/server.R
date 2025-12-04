import_server <- function(data, y) {
  source("modules/helpers.R")
  source_dir("modules/server")

  data_process_result <- process_input_data(data)
  data <- data_process_result$data
  available_variables <- data_process_result$available_variables
  exports <- new.env(parent = emptyenv())

  server <- function(input, output, session) {
    shared_env <- list2env(list(
      input = input,
      output = output,
      data = data,
      available_variables = available_variables
    ))

    # Build vector resuming which Date or POSIXct columns are contained in input dataset
    dates_variable_list <- reactive({
      req(data) # ensure data is available
      get_date_columns(data)
    })

    target <- reactiveValues(value = NA)
    features <- reactiveValues(list = list())

    source_dir("modules/server/reactive/sections", local = shared_env)
    source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
    source_dir("modules/server/reactive/sections/train_models", local = shared_env)

    # expose handles so outer app can reuse XAI payloads and context
    exports$xai_payload <- shared_env$xai_payload
    exports$model_context <- shared_env$model_context
  }

  list(server = server, exports = exports)
}
