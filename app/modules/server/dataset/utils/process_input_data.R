is_id_column <- function(x, colname) {
  # High-cardinality categorical OR name ending with "id"
  (is.character(x) || is.factor(x)) && length(unique(x)) > 0.5 * length(x) ||
    grepl("id$", colname, ignore.case = TRUE)
}


process_input_data <- function(data, session = shiny::getDefaultReactiveDomain()) {

  data <- data.table(data)

  if (nrow(data) > 1e6) {
    stop("Input dataset must not exceed one million rows")
  }

  original_colnames <- colnames(data)

  sanitized_colnames <- original_colnames %>%
    str_replace_all("^\\W+|\\W+$", "") %>%   # remove symbols at start or end
    make.names(unique = TRUE)                # ensure valid and unique names

  colnames(data) <- sanitized_colnames

  # Identify columns that were modified
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

  #  --- Detect and remove ID-like columns ---
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

  #  --- Remove date/POSIXct columns ---
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

  list(
    data = data,
    available_variables = colnames(data),
    date_columns = date_columns,
    id_columns = id_cols
  )
}
