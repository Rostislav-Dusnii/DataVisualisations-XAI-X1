feature_importance <- argonTab(
  tabName = "Feature importance",
  active = FALSE,
  div(
    align = "center",
    br(),
    br(),
    uiOutput("message_feature_importance"),
    uiOutput("feature_importance_glm_message")
  ),
  withSpinner(plotlyOutput("feature_importance", height = "100%"))
)
