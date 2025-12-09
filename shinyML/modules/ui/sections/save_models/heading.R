heading <- div(
  align = "center",
  argonButton(
    name = HTML(
      "<font size='+1'>&nbsp; Overview and save models</font>"
    ),
    status = "default",
    icon = icon("tools"),
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_configure_parameters"
  ),
  argonModal(
    id = "modal_configure_parameters",
    title = HTML("<b>OVERVIEW AND SAVE MODELS</b>"),
    status = "default",
    gradient = TRUE,
    br(),
    HTML(
      "<b>Review the models, their frameworks and save them locally</b>"
    )
  )
)
