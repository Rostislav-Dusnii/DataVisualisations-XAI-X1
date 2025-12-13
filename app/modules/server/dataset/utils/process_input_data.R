# checks if column is high-cardinality or ID-like
is_id_column <- function(x, colname) {
  (is.character(x) || is.factor(x)) && length(unique(x)) > 0.5 * length(x) ||
    grepl("id$", colname, ignore.case = TRUE)
}


# sanitizes column names, removes ID and date columns
process_input_data <- function(data, session = shiny::getDefaultReactiveDomain()) {

  data <- data.table(data)

  # row limit
  if (nrow(data) > 1e6) {
    stop("Input dataset must not exceed one million rows")
  }

  # sanitize column names
  original_colnames <- colnames(data)

  sanitized_colnames <- original_colnames %>%
    str_replace_all("^\\W+|\\W+$", "") %>%
    make.names(unique = TRUE)

  colnames(data) <- sanitized_colnames

  # warn about renamed columns
  changed_cols <- original_colnames[original_colnames != sanitized_colnames]
  if (length(changed_cols) > 0) {
    show_alert(
      session = session,
      title = "Column names sanitized",
      text = paste0(
        "The following columns began or ended with symbols and were renamed:\n",
        paste(changed_cols, collapse = ", ")
      ),
      type = "warning"
    )
  }

  # detect and remove ID columns
  id_cols <- c()
  for (col in colnames(data)) {
    if (is_id_column(data[[col]], col)) {
      id_cols <- c(id_cols, col)
    }
  }

  if (length(id_cols) > 0) {
    data[, (id_cols) := NULL]

    show_alert(
      session = session,
      title = "ID columns removed",
      text = paste0(
        "The following high-cardinality or ID-like columns were removed:\n",
        paste(id_cols, collapse = ", ")
      ),
      type = "warning"
    )
  }

  # remove date columns
  date_columns <- get_date_columns(data)
  ts_columns <- date_columns[date_columns %in% colnames(data)]

  if (length(ts_columns) > 0) {
    data[, (ts_columns) := NULL]

    show_alert(
      session = session,
      title = "Date columns removed",
      text = paste0(
        "The following date/POSIXct columns were removed from the dataset:\n",
        paste(ts_columns, collapse = ", ")
      ),
      type = "warning"
    )
  }

  # return processed data and metadata
  list(
    data = data,
    available_variables = colnames(data),
    date_columns = date_columns,
    id_columns = id_cols
  )
}
