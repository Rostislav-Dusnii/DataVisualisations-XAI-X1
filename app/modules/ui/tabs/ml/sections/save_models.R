source_dir(PATH_UI_SAVE_MODELS)

save_models <- argonDashHeader(
  gradient = TRUE,
  color = "light",
  separator = FALSE,
  heading,
  br(),
  uiOutput("save_models_selection")
)
