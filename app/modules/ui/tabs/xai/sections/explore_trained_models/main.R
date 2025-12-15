# Container for model studio tabs
main <- argonColumn(
  width = 12,
  argonCard(
    width = 12, shadow = TRUE,
    uiOutput("message_no_trained_models"),
    withSpinner(uiOutput("model_studio_tabs"))
  )
)
