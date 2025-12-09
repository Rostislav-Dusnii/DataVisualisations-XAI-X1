import_server <- function(data) {
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
      session = session,
      data = data,
      available_variables = available_variables
    ))

    source("modules/server/reactive/sections/dataset.R", local = shared_env)
    source("modules/server/reactive/sections/summary.R", local = shared_env)
    source_dir("modules/server/reactive/sections/train_models", local = shared_env)
    source_dir("modules/server/reactive/sections/import_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
    source_dir("modules/server/reactive/sections/save_models", local = shared_env)

    # expose handles so outer app can reuse XAI payloads and context
    exports$xai_payload <- shared_env$xai_payload
    exports$model_context <- shared_env$model_context
  }

  list(server = server, exports = exports)
}
