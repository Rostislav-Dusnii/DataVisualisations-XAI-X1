all_models <- argonColumn(
  width = 6,
  argonCard(
    width = 12,
    icon = icon("cogs"),
    status = "warning",
    title = "Compare all models",
    div(
      align = "center",
      argonH1("Click this button to run all model simultaneously", display = 4),
      argonH1(HTML("<small><i> The four models will be runed with the parameters selected above</i></small>"), display = 4),
      br(),
      br(),
      actionBttn(label = "Run all models !", inputId = "train_all", color = "primary", icon = icon("cogs", lib = "font-awesome")),
      br()
    )
  )
)
