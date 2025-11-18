explore_results <- function() {
  source("modules/ui/sections/explore_results/heading.R")
  source("modules/ui/sections/explore_results/main.R")

  section <- argonDashHeader(
    gradient = TRUE,
    color = "primary",
    separator = FALSE,
    heading,
    br(),
    main
  )

  list(section = section)
}
