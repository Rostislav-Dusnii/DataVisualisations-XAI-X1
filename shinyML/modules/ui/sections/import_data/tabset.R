source_dir("modules/ui/sections/import_data/tabs")

tabset <- argonTabSet(
  width = 12,
  id = "tab_import_data",
  card_wrapper = TRUE,
  horizontal = TRUE,
  circle = FALSE,
  size = "sm",
  import_data,
  edit_imported_data,
  review_data
)
