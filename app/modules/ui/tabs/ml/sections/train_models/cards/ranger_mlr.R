ranger_mlr <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "success",
  title = "mlr framework",
  div(
    align = "center",
    h1("Ranger Regression"),
    checkboxInput("select_ranger_mlr", "Select model", value = FALSE)
  )
)
