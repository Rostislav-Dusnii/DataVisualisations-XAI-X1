# gradient boosting model card
gb_h2o <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "primary",
  title = "h2o framework",
  div(
    align = "center",
    h1("Gradient boosting"),
    sliderInput(label = "Max depth", min = 1, max = 20, inputId = "max_depth_gbm", value = 5),
    sliderInput(label = "Number of trees", min = 1, max = 100, inputId = "n_trees_gbm", value = 50),
    sliderInput(label = "Sample rate", min = 0.1, max = 1, inputId = "sample_rate_gbm", value = 1),
    sliderInput(label = "Learn rate", min = 0.1, max = 1, inputId = "learn_rate_gbm", value = 0.1),
    checkboxInput("select_gb_h2o", "Select model", value = FALSE)
  )
)
