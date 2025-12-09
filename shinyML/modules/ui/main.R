source("modules/ui/sections/summary.R")
source("modules/ui/sections/import_data.R")
source("modules/ui/sections/explore_imported_data.R")
source("modules/ui/sections/train_models.R")
source("modules/ui/sections/explore_results.R")
source("modules/ui/sections/save_models.R")


# # page 2 content
# source("modules/ui/sections/page2.R")
# page2_content_module <- page2()

# # page 3 content
# source("modules/ui/sections/page3.R")
# page3_content_module <- page3()

# # header
# header <- summary_ui


main <- argonColumn(
  width = "100%",
  summary,
  import_data,
  explore_imported_data,
  train_models,
  explore_results,
  save_models
)



  # all_pages <- tags$div(
  #   id = "main_tabs",
  #   conditionalPanel(
  #     condition = "input.current_page == 'page1' || typeof input.current_page === 'undefined'",
  #     explore_imported_data$section,
  #     train_models$section,
  #     explore_results_ui
  #   ),
  #   conditionalPanel(
  #     condition = "input.current_page == 'page2'",
  #     page2_content_module$section
  #   ),
  #   conditionalPanel(
  #     condition = "input.current_page == 'page3'",
  #     page3_content_module$section
  #   )
  # )
