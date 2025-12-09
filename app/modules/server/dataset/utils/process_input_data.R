process_input_data <- function(data, session = shiny::getDefaultReactiveDomain()) {
  # Convert input dataset to data.table
  data <- data.table(data)

  # Check if dataset has more than 1 million rows
  if (nrow(data) > 1e6) {
    stop("Input dataset must not exceed one million rows")
  }

  # Original column names
  original_colnames <- colnames(data)

  # Remove symbols at the beginning or end of column names
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
  list(
    data = data,
    available_variables = sanitized_colnames
  )
}