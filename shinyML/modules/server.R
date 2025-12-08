import_server <- function(data) {
  source("modules/helpers.R")
  source_dir("modules/server")

  server <- function(input, output, session) {
    shared_env <- list2env(list(
      input = input,
      output = output,
      data = data
    ))

    source("modules/server/reactive/sections/dataset.R", local = shared_env)
    source("modules/server/reactive/sections/summary.R", local = shared_env)
    source_dir("modules/server/reactive/sections/train_models", local = shared_env)
    source_dir("modules/server/reactive/sections/import_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
  }

  list(server = server)
}
