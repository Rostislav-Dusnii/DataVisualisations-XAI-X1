source(path(PATH_UI_EXP_RESULTS,"heading.R"))
source(path(PATH_UI_EXP_RESULTS,"main.R"))

explore_results <- argonDashHeader(
  gradient = TRUE,
  color = "primary",
  separator = FALSE,
  heading,
  br(),
  main
)
