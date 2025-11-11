sidebar <- argonColumn(
  width = 3,
  argonCard(
    width = 12, src = NULL, hover_lift = TRUE, shadow = TRUE,
    div(
      align = "center",
      argonColumn(width = 6, uiOutput("Time_series_checkbox")),
      argonColumn(width = 6, uiOutput("time_series_column")),
      uiOutput("Variables_input_selection"),
      uiOutput("slider_time_series_train"),
      uiOutput("slider_time_series_test"),
      uiOutput("slider_percentage"),
      uiOutput("message_nrow_train_dataset")
    )
  )
)
