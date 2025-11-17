# Time series strategy
prepare_time_series <- function(data, input, test_1, test_2, train_1) {
  req(!is.null(test_1$date))

  data_train <- data.table()
  data_test <- data.table()

  data_results <- eval(parse(text = paste0(
    "data[", input$time_series_select_column, ">'", test_1$date,
    "',][", input$time_series_select_column, "< '", test_2$date, "',]"
  )))

  data_h2o_train <- as.h2o(eval(parse(text = paste0(
    "data[", input$time_series_select_column, "<='", test_1$date,
    "',][", input$time_series_select_column, ">='", train_1$date,
    "',][, !'", input$time_series_select_column, "']"
  ))))

  data_h2o_test <- as.h2o(eval(parse(text = paste0(
    "data[", input$time_series_select_column, ">'", test_1$date,
    "',][", input$time_series_select_column, "< '", test_2$date,
    "',][, !'", input$time_series_select_column, "']"
  ))))

  list(
    data_train = data_train,
    data_test = data_test,
    data_h2o_train = data_h2o_train,
    data_h2o_test = data_h2o_test
  )
}

# Non–time-series strategy
prepare_non_time_series <- function(data, input, test_1, test_2, train_1) {
  req(!is.null(input$train_test_split_slider))

  data_train <- data %>%
    sample_frac(as.numeric(as.character(gsub("%", "", input$train_test_split_slider))) * 0.01)

  data_test <- data %>% anti_join(data_train, by = colnames(data))
  list(
    data_train = data_train,
    data_test = data_test,
    data_h2o_train = as.h2o(data_train),
    data_h2o_test = as.h2o(data_test)
  )
}
