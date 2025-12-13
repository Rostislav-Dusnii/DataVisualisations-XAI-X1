# scatter plot tab with axis selectors
explore_dataset <- argonTab(
  tabName = "Explore dataset",
  active = TRUE,
  argonRow(
    argonColumn(
      width = 6,
      div(
        align = "center",
        uiOutput("x_axis_explore_dataset")
      )
    ),
    argonColumn(
      width = 6,
      div(
        align = "center",
        uiOutput("y_axis_explore_dataset")
      )
    )
  ),
  br(),
  br(),
  br(),
  withSpinner(
    plotlyOutput(
      "dataset_chart",
      width = "100%",
      height = "120%"
    )
  )
)