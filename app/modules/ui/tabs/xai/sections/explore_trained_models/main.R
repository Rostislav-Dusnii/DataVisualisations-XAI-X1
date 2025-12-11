main <- argonColumn(
  width = 12,
  argonCard(
    width = 12, shadow = TRUE,
    uiOutput("message_no_trained_models"),
    uiOutput("model_studio_tabs")
  )
)
