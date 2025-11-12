select_parameters <- function() {
  source("modules/ui/sections/select_parameters/heading.R")
  source("modules/ui/sections/select_parameters/main.R")

  section <- argonDashHeader(
    gradient = TRUE,
    color = "default",
    separator = FALSE,
    heading,
    br(),
    models_actions,
    groupped_actions
  )
  list(section = section)
}
