source(path(PATH_UI_XAI_EXP_MODELS,"heading.R"))
source(path(PATH_UI_XAI_EXP_MODELS,"main.R"))

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
