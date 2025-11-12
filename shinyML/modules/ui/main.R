main <- function(data = data, y = y) {
  source("modules/ui/sections/summary.R")
  summary <- summary()

  source("modules/ui/sections/explore_imported_data.R")
  explore_imported_data <- explore_imported_data(data = data, y = y)

  source("modules/ui/sections/select_parameters.R")
  select_parameters <- select_parameters()

  source("modules/ui/sections/explore_results.R")
  explore_results <- explore_results()

  sections <- argonColumn(
    width = "100%",
    summary$ui,
    explore_imported_data$section,
    select_parameters$section,
    explore_results$section
  )

  list(ui = sections)
}
