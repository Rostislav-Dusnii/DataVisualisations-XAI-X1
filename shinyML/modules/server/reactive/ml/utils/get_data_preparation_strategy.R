get_data_strategy <- function(is_time_series) {
  if (isTRUE(is_time_series)) {
    return(prepare_time_series)
  } else {
    return(prepare_non_time_series)
  }
}
