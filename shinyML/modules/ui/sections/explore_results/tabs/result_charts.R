result_charts <- argonTab(
  tabName = "Result charts on test period",
  active = TRUE,
  withSpinner(dygraphOutput("pred_vs_real_chart", width = "100%")),
  br(),
  div(
    align = "center",
    switchInput(
      label = "Bar chart mode",
      inputId = "bar_chart_mode",
      value = TRUE
    )
  )
)
