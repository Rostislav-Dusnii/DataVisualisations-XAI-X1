# Load XAI explore models UI components
source(path(PATH_UI_XAI_EXP_MODELS,"heading.R"))
source(path(PATH_UI_XAI_EXP_MODELS,"main.R"))

# XAI explore trained models section
explore_trained_models <- argonDashHeader(
  gradient = TRUE,
  color = "dark",
  separator = FALSE,
  heading,
  br(),
  argonRow(
    main
  )
)
