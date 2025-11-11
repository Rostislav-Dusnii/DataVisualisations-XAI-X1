result_charts <- argonTab(
  tabName = "Result charts on test period",
  active = TRUE,
  withSpinner(dygraphOutput("output_curve", width = "100%")),
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
