main <- function(data = data) {
  source("modules/ui/sections/summary.R")
  summary <- summary()

  source("modules/ui/sections/explore_imported_data.R")
  explore_imported_data <- explore_imported_data(data = data)

  source("modules/ui/sections/train_models.R")
  train_models <- train_models()

  source("modules/ui/sections/explore_results.R")
  explore_results <- explore_results()

  # page 2 content
  source("modules/ui/sections/page2.R")
  page2_content_module <- page2()

  # page 3 content
  source("modules/ui/sections/page3.R")
  page3_content_module <- page3()

  # header
  header <- summary$ui

  all_pages <- tags$div(
    id = "main_tabs",
    conditionalPanel(
      condition = "input.current_page == 'page1' || typeof input.current_page === 'undefined'",
      explore_imported_data$section,
      train_models$section,
      explore_results$section
    ),
    conditionalPanel(
      condition = "input.current_page == 'page2'",
      page2_content_module$section
    ),
    conditionalPanel(
      condition = "input.current_page == 'page3'",
      page3_content_module$section
    )
  )

  list(ui = all_pages, header = header)
}
