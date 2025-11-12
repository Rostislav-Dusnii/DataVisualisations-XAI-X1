heading <- div(
  align = "center",
  argonButton(
    name = HTML(
      "<font size='+1'>&nbsp; Configure parameters and run models</font>"
    ),
    status = "default",
    icon = icon("tools"),
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_configure_parameters"
  ),
  argonModal(
    id = "modal_configure_parameters",
    title = HTML("<b>CONFIGURE PARAMETERS</b>"),
    status = "default",
    gradient = TRUE,
    br(),
    HTML(
      "<b>Compare different machine learning techniques with your own
      hyper-parameters configuration.</b>"
    ),
    br(), br(),
    HTML(
      "You are free to select hyper-parameters configuration for each
      machine learning model using different cursors.<br><br>"
    ),
    HTML(
      "Each model can be launched separately by clicking the corresponding
      button; you can also launch all models simultaneously using
      'Run all models!' button.<br><br>"
    ),
    HTML(
      "Please note that the autoML algorithm will automatically find the
      best algorithm to suit your regression task: the user will be informed
      of the machine learning technique used and know which hyper-parameters
      should be configured."
    )
  )
)
