source_dir(PATH_UI_TRAIN_CARDS)

models_selection <- argonRow(
  glm_h2o,
  rf_h2o,
  nn_h2o,
  gb_h2o,
  ranger_mlr
)
