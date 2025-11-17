sidebar <- argonColumn(
  width = 3,
  argonCard(
    width = 12, src = NULL, hover_lift = TRUE, shadow = TRUE,
    div(
      align = "center",
      uiOutput("input_variables_selection"),
      uiOutput("message_nrow_train_dataset")
    )
  )
)
