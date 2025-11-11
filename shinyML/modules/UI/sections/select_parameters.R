select_parameters <- function() {
  source("modules/UI/sections/select_parameters/heading.R")
  source("modules/UI/sections/select_parameters/main.R")

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
