process_input_data <- function(data) {
  # Convert input dataset to data.table
  data <- data.table::data.table(data)
  # Check if dataset has more than 1 million rows
  if (nrow(data) > 1e6) {
    stop("Input dataset must not exceed one million rows")
  }

  colnames(data) <- make.names(colnames(data), unique = TRUE)

  available_variables <- colnames(data)

  list(
    data = data,
    available_variables = available_variables
  )
}
