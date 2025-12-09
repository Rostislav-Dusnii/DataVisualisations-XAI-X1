feature_importance <- argonTab(
  tabName = "Feature importance",
  active = FALSE,
  div(
    align = "center",
    br(),
    br(),
    uiOutput("message_feature_importance"),
    uiOutput("glm_feature_importance_message")
  ),
  withSpinner(plotlyOutput("feature_importance", height = "100%"))
)
