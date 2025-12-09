source_dir(PATH_UI_ML_SECTIONS)

ml_tab_ui <- argonDashBody(
  argonColumn(
  width = "100%",
  summary,
  import_data,
  explore_imported_data,
  train_models,
  explore_results,
  save_models
))