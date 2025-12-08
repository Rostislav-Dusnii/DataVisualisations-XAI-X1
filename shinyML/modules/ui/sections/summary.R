summary <- argonDashHeader(
  gradient = TRUE,
  color = "danger",
  separator = FALSE,
  argonRow(
    argonColumn(
      width = "20%",
      argonInfoCard(
        value = "Regression", gradient = TRUE, width = 12,
        title = "Machine learning task",
        icon = icon("chart-bar"),
        icon_background = "red",
        background_color = "lightblue"
      )
    ),
    argonColumn(width = "20%", uiOutput("dataset_infoCard"))
  )
)
