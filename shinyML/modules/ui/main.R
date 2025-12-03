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

  # create tabset with all pages
  all_pages <- tabsetPanel(
      id = "main_tabs",
      type = "tabs",
      tabPanel(
        "Page 1",
        value = "page1",
        explore_imported_data$section,
        train_models$section,
        explore_results$section
      ),
      tabPanel(
        "Page 2",
        value = "page2",
        page2_content_module$section
      ),
      tabPanel(
        "Page 3",
        value = "page3",
        page3_content_module$section
      )
    )

  list(ui = all_pages, header = header)
}
