correlation_matrix <- argonTab(
  tabName = "Correlation matrix",
  active = FALSE,
  withSpinner(
    plotlyOutput("correlation_matrix", height = "100%", width = "100%")
  )
)
