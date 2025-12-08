explore_imported_data <- function(data) {
  source("modules/ui/sections/explore_imported_data/heading.R")
  source("modules/ui/sections/explore_imported_data/main.R")
  main <- main(data)
  source("modules/ui/sections/explore_imported_data/sidebar.R")

  section <- argonDashHeader(
    gradient = TRUE,
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
