# Load results UI components
source(path(PATH_UI_EXP_RESULTS,"heading.R"))
source(path(PATH_UI_EXP_RESULTS,"main.R"))

# Explore results section
explore_results <- argonDashHeader(
  gradient = TRUE,
  color = "primary",
  separator = FALSE,
  heading,
  br(),
  main
)
