compare_performance <- argonTab(
  tabName = "Compare models performances",
  active = FALSE,
  div(
    align = "center",
    br(),
    br(),
    uiOutput("message_compare_models_performances")
  ),
  withSpinner(DTOutput("model_performance_comparison"))
)
