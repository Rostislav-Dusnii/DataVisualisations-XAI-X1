create_shinyML_Server <- function(data, y) {
  source("modules/helpers.R")
  source_dir("modules/server")

  res <- process_input_data(data, y)
  data <- res$data
  y <- res$y
  x <- res$x


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
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
    source_dir("modules/server/reactive/sections/train_models", local = shared_env)
  }

  list(server = server)
}
