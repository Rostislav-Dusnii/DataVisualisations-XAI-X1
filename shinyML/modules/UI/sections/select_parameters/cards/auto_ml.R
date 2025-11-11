auto_ml <- argonColumn(
  width = 6,
  argonCard(
    width = 12, icon = icon("cogs"), status = "warning", title = "Auto Machine Learning",
    div(
      align = "center",
      prettyCheckboxGroup(
        inputId = "auto_ml_autorized_models",
        label = HTML("<b>Authorized searching</b>"),
        choices = c("DRF", "GLM", "XGBoost", "GBM", "DeepLearning"),
        selected = c("DRF", "GLM", "XGBoost", "GBM", "DeepLearning"),
        icon = icon("check-square-o"),
        status = "primary",
        inline = TRUE,
        outline = TRUE,
        animation = "jelly"
      ),
      br(),
      knobInput(
        inputId = "run_time_auto_ml", label = HTML("<b>Max running time (in seconds)</b>"), value = 15, min = 10, max = 60,
        displayPrevious = TRUE, lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"
      ),
      actionButton("run_auto_ml", "Run auto ML", style = "color:white; background-color:red; padding:4px; font-size:120%", icon = icon("cogs", lib = "font-awesome"))
    )
  )
)
