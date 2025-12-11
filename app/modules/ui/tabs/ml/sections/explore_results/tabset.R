source_dir(PATH_UI_EXP_RESULTS_TABS)

tabset <- argonTabSet(
  width = 12,
  id = "results_models",
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
  compare_performance,
  table_results
)
