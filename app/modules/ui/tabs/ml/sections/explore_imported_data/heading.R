# explore data section header with info modal
heading <- div(
  align = "center",
  argonButton(
    name = HTML("<font size='+1'>&nbsp;  Explore input data </font>"),
    status = "info",
    icon = icon("chart-area"),
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_explore_input_data"
  ),
  argonModal(
    id = "modal_explore_input_data",
    title = HTML("<b>EXPLORE INPUT DATA</b>"),
    status = "info",
    gradient = TRUE,
    br(),
    HTML(
      "<b>Before running machine learning models, it can be useful to inspect
      each variable distribution and dependencies between explanatory variables.</b>"
    ),
    br(), br(),
    HTML(
      "This section allows you to plot variable variations, check classes,
      histograms, and correlation matrix.<br><br>Some variables may be removed
      from training if highly correlated."
    )
  )
)
