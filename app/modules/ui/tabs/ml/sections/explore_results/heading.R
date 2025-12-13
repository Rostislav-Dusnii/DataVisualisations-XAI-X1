# explore results section header with info modal
heading <- div(
  align = "center",
  argonButton(
    name = HTML("<font size='+1'>&nbsp; Explore results</font>"),
    status = "primary",
    icon = icon("list-ol"),
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_explore_results"
  ),
  argonModal(
    id = "modal_explore_results",
    title = HTML("<b>EXPLORE RESULTS</b>"),
    status = "primary",
    gradient = TRUE,
    br(),
    HTML(
      "<b>Once machine learning models have been lauched, this section can be
      used to compare their performances on the testing dataset</b>"
    ),
    br(), br(),
    HTML(
      "You can check confusion matrices to get classification results for each
      model or have an overview of error metric in 'Compare models performances'
      tab.<br><br>"
    ),
    HTML(
      "Please note that feature importances of each model are available in the
      corresponding tab."
    )
  )
)
