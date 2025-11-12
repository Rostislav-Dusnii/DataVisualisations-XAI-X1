explore_results <- function() {
  source("modules/ui/sections/explore_results/heading.R")
  source("modules/ui/sections/explore_results/main.R")
  source("modules/ui/sections/explore_results/save_models_button.R")

  section <- argonDashHeader(
    gradient = TRUE,
    color = "primary",
    separator = FALSE,
    heading,
    br(),
    main,
    save_models_button
  )

  list(section = section)
}
