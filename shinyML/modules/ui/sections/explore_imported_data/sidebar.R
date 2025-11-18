sidebar <- argonColumn(
  width = 3,
  argonCard(
    width = 12, src = NULL, hover_lift = TRUE, shadow = TRUE,
    div(
      align = "center",
      uiOutput("features_selection"),
      uiOutput("target_selection"),
      uiOutput("message_train_test_split"),
      uiOutput("message_nrow_train_dataset")
    )
  )
)
