# Main Shiny server function
server <- function(input, output, session) {
  # Shared environment for all modules
  shared_env <- list2env(list(
    input = input,
    output = output,
    session = session
  ))
  # Load server modules
  source_dir(PATH_DATASET, local = shared_env)
  source(path(PATH_SHARED,"shared.R"), local = shared_env)
  source(path(PATH_SHARED,"explainers.R"), local = shared_env)
  source_dir(PATH_TABS, local = shared_env)

  # Handle tab switching
  observeEvent(input$navbar_switch, {
    session$sendCustomMessage("switch_page", input$navbar_switch)
  })
}