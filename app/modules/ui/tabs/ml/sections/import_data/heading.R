# import data section header with info modal
heading <- div(
  align = "center",
  argonButton(
    name = HTML("<font size='+1'>&nbsp;  Import data </font>"),
    status = "secondary",
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_import_data"
  ),
  argonModal(
    id = "modal_import_data",
    title = HTML("<b>IMPORT DATA</b>"),
    status = "secondary",
    gradient = TRUE,
    br(),
    HTML(
      "This section allows you to import a new dataset, review, partially modify the imported dataset"
    )
  )
)
