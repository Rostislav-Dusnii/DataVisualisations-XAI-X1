neural_network <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "primary",
  title = "Neural network",
  div(
    align = "center",
    argonRow(
      argonColumn(
        width = 6,
        radioButtons(label = "Activation function", inputId = "activation_neural_net", choices = c("Rectifier", "Maxout", "Tanh", "RectifierWithDropout", "MaxoutWithDropout", "TanhWithDropout"), selected = "Rectifier")
      ),
      argonColumn(
        width = 6,
        radioButtons(label = "Loss function", inputId = "loss_neural_net", choices = c("Automatic", "Quadratic", "Huber", "Absolute", "Quantile"), selected = "Automatic")
      )
    ),
    textInput(label = "Hidden layers", inputId = "hidden_neural_net", value = "c(200,200)"),
    sliderInput(label = "Epochs", min = 10, max = 100, inputId = "epochs_neural_net", value = 10),
    sliderInput(label = "Learning rate", min = 0.001, max = 0.1, inputId = "rate_neural_net", value = 0.005),
    checkboxInput("select_nn", "Select model", value = FALSE)
  )
)
