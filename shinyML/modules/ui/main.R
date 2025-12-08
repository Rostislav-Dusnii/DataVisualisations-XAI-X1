main <- function(data = data) {
  source("modules/ui/sections/summary.R")
  summary <- summary()

  source("modules/ui/sections/explore_imported_data.R")
  explore_imported_data <- explore_imported_data(data = data)

  source("modules/ui/sections/train_models.R")
  train_models <- train_models()

  source("modules/ui/sections/explore_results.R")
  explore_results <- explore_results()

  sections <- argonColumn(
    width = "100%",
    summary$ui,
    explore_imported_data$section,
    train_models$section,
    explore_results$section
  )

  list(ui = sections)
}
