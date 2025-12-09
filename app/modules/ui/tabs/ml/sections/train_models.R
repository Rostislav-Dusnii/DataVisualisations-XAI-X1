source_dir(PATH_UI_TRAIN_MODELS)

train_models <- argonDashHeader(
  gradient = TRUE,
  color = "default",
  separator = FALSE,
  heading,
  br(),
  models_selection,
  actionButton("train_models_btn",
    "Train Models",
    style = "color:white; background-color:red; padding:4px; font-size:120%",
    icon = icon("cogs", lib = "font-awesome")
  )
)
