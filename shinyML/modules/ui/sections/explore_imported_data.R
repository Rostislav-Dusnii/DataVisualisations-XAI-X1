source("modules/ui/sections/explore_imported_data/heading.R")
source("modules/ui/sections/explore_imported_data/main.R")

explore_imported_data <- argonDashHeader(
  gradient = FALSE,
  color = "info",
  separator = FALSE,
  heading,
  br(),
  argonRow(
    main
  )
)
