explore_imported_data <- function(data, y) {
  source("modules/UI/sections/explore_imported_data/heading.R")
  source("modules/UI/sections/explore_imported_data/main.R")
  main <- main(data, y)
  source("modules/UI/sections/explore_imported_data/sidebar.R")

  section <- argonDashHeader(
    gradient = FALSE,
    color = "info",
    separator = FALSE,
    heading,
    br(),
    argonRow(
      main$ui,
      sidebar
    )
  )
  list(section = section)
}
