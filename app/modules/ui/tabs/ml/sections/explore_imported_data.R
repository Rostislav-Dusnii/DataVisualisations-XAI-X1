# Load explore data UI components
source(path(PATH_UI_EXP_IMPORT,"heading.R"))
source(path(PATH_UI_EXP_IMPORT,"main.R"))

# Explore imported data section
explore_imported_data <- argonDashHeader(
  gradient = TRUE,
  color = "info",
  separator = FALSE,
  heading,
  br(),
  argonRow(
    main
  )
)
