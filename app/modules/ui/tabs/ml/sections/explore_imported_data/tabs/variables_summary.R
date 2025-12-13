# variable table and distribution plots tab
variables_summary <- argonTab(
  tabName = "Variables Summary",
  active = FALSE,
  fluidRow(
    argonColumn(
      width = 4, br(), br(),
      withSpinner(DTOutput("variables_class_input", height = "100%", width = "100%"))
    ),
    argonColumn(
      width = 8,
      div(
        align = "center",
        radioButtons(
          inputId = "input_var_graph_type",
          label = "",
          choices = c("Histogram", "Boxplot", "Autocorrelation"),
          selected = "Histogram", inline = TRUE
        )
      ),
      withSpinner(plotlyOutput("variable_graph", height = "100%", width = "100%"))
    )
  )
)
