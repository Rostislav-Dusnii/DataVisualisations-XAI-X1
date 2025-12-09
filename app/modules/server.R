server <- function(input, output, session) {
  shared_env <- list2env(list(
    input = input,
    output = output,
    session = session
  ))
  source_dir(PATH_DATASET, local = shared_env)
  source(path(PATH_SERVER,"shared.R"), local = shared_env)
  # print(current_dataset$data)
  source_dir(PATH_TABS, local = shared_env)

  observeEvent(input$navbar_switch, {
    session$sendCustomMessage("switch_page", input$navbar_switch)
  })
}