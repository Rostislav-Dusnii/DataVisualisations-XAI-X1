explore_imported_data <- function(data) {
  source("modules/ui/sections/explore_imported_data/heading.R")
  source("modules/ui/sections/explore_imported_data/main.R")
  main_ui <- main
  source("modules/ui/sections/import_data/sidebar.R")

  section <- argonDashHeader(
    gradient = TRUE,
    color = "info",
    separator = FALSE,
    heading,
    br(),
    argonRow(
      main_ui,
      sidebar
    )
  )
  list(section = section)
}
