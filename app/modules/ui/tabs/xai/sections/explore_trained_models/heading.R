heading <- div(
  align = "center",
  argonButton(
    name = HTML("<font size='+1'>&nbsp;  Explore trained models </font>"),
    status = "info",
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_explore_trained_models"
  ),
  argonModal(
    id = "modal_explore_trained_models",
    title = HTML("<b>EXPLORE TRAINED MODELS</b>"),
    status = "info",
    gradient = TRUE,
    br(),
    HTML(
      "<b>Experiment and study trained models parameters with XAI techniques. </b>"
    )
  )
)
