sidebar <- argonColumn(
  width = 3,
  argonCard(
    width = 12, src = NULL, hover_lift = TRUE, shadow = TRUE,
    div(
      align = "center",
      argonColumn(width = 6, uiOutput("time_series_checkbox")),
      argonColumn(width = 6, uiOutput("time_series_column")),
      uiOutput("input_variables_selection"),
      uiOutput("slider_time_series_train"),
      uiOutput("train_test_split_slider"),
      uiOutput("message_nrow_train_dataset")
    )
  )
)
