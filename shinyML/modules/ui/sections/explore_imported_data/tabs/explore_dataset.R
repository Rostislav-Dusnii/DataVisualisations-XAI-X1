explore_dataset <- function(data, y) {
  ui <- argonTab(
    tabName = "Explore dataset",
    active = TRUE,
    argonRow(
      argonColumn(
        width = 6,
        div(
          align = "center",
          uiOutput("X_axis_explore_dataset")
        )
      ),
      argonColumn(
        width = 6,
        div(
          align = "center",
          selectInput(
            inputId = "y_variable_input_curve",
            label = "Y-axis variable",
            choices = colnames(data),
            selected = y
          )
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
  list(ui = ui)
}
