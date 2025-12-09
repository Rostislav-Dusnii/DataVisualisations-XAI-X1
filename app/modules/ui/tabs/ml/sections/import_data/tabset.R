source_dir(PATH_UI_IMPORT_TABS)

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
