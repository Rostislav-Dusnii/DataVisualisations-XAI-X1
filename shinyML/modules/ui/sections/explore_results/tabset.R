source_dir("modules/ui/sections/explore_results/tabs")

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
  result_charts,
  compare_performance,
  feature_importance,
  table_results
)
