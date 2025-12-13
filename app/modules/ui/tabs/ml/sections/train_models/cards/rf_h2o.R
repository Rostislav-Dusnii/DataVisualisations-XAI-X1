# random forest model card
rf_h2o <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "primary",
  title = "h2o framework",
  div(
    align = "center",
    h1("Random Forest"),
    sliderInput(label = "Number of trees", min = 1, max = 100, inputId = "num_tree_random_forest", value = 50),
    sliderInput(label = "Subsampling rate", min = 0.1, max = 1, inputId = "subsampling_rate_random_forest", value = 0.6),
    sliderInput(label = "Max depth", min = 1, max = 50, inputId = "max_depth_random_forest", value = 20),
    sliderInput(label = "Number of bins", min = 2, max = 100, inputId = "n_bins_random_forest", value = 20),
    checkboxInput("select_rf_h2o", "Select model", value = FALSE)
  )
)
