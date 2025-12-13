# Load all ML tab sections
source_dir(PATH_UI_ML_SECTIONS)

# ML tab main layout - combines all sections
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