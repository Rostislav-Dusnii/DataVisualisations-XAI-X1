source_dir(PATH_UI_EXP_IMPORT_TABS)

# data exploration tabset
tabset <- argonTabSet(
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
  explore_dataset,
  variables_summary,
  correlation_matrix
)
