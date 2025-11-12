tabset <- function(data, y) {
  source_dir("modules/ui/sections/explore_imported_data/tabs")

  explore_dataset <- explore_dataset(data, y)

  ui <- argonTabSet(
    width = 12,
    id = "tab_input_data",
    card_wrapper = TRUE,
    horizontal = TRUE,
    circle = FALSE,
    size = "sm",
    iconList = list(
      argonIcon("cloud-upload-96"),
      argonIcon("bell-55"),
      argonIcon("calendar-grid-58"),
      argonIcon("calendar-grid-58")
    ),
    explore_dataset$ui,
    variables_summary,
    correlation_matrix
  )
  list(ui = ui)
}
