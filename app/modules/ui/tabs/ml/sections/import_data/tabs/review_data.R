review_data <- argonTab(
  tabName = "Review data",
  active = FALSE,
  theme = bslib::bs_theme(version = 5L),
  shinyWidgets::html_dependency_winbox(),
  actionButton(
    inputId = "show1",
    label = "Show data in popup",
    icon = icon("eye")
  ),
  actionButton(
    inputId = "show2",
    label = "Show data in modal",
    icon = icon("eye")
  ),
  actionButton(
    inputId = "show3",
    label = "Show data without classes",
    icon = icon("eye")
  ),
  actionButton(
    inputId = "show4",
    label = "Show data in Winbox",
    icon = icon("eye")
  )
)
