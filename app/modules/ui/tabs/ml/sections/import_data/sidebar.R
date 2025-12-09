sidebar <- argonColumn(
  width = 3,
  argonCard(
    width = 12, src = NULL, shadow = TRUE,
    div(
      align = "center",
      uiOutput("features_selection"),
      uiOutput("target_selection"),
      uiOutput("message_train_test_split"),
      uiOutput("message_nrow_train_dataset"),
      uiOutput("message_not_enough_data"),
      uiOutput("message_time_series_not_supported")
    )
  )
)
