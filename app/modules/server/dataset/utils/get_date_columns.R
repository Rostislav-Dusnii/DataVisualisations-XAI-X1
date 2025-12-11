get_date_columns <- function(data) {
  dates_columns_list <- c()
  for (i in colnames(data)) {
    if (inherits(data[[i]], "Date") || inherits(data[[i]], "POSIXct")) {
      dates_columns_list <- c(dates_columns_list, i)
    }
  }
  dates_columns_list
}

