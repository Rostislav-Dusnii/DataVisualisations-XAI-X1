source("modules/ui/sections/explore_results/heading.R")
source("modules/ui/sections/explore_results/main.R")

explore_results <- argonDashHeader(
  gradient = TRUE,
  color = "primary",
  separator = FALSE,
  heading,
  br(),
  main
)
