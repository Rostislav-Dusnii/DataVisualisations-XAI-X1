source_dir(PATH_UI_XAI_SECTIONS)

# xai_tab_ui <- tagList(
#   tags$div(
#     style = "padding: 20px;",
#     h2("Model Explanations - Arena.drwhy"),
#     tags$p("Visualize and explore your trained models with interactive explanations."),
#     fluidRow(
#       column(6, uiOutput("model_selector")),
#       column(6, downloadButton("download_explainer", "Download DALEX Explainer (.rds)", class = "btn-primary"))
#     ),
#     tags$div(
#       id = "arena_container",
#       style = "min-height: 600px; margin-top: 20px;",
#       uiOutput("arena_output")
#     )
#   )
# )

xai_tab_ui <- argonDashBody(
  argonColumn(
  width = "100%",
  explore_trained_models
))