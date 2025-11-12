process_input_data <- function(data, y) {
  # Convert input dataset to data.table
  data <- data.table::data.table(data)

  # Replace '.' by '_' in dataset column names
  colnames(data) <- gsub("\\.", "_", colnames(data))

  # Replace '.' by '_' in output variable name
  y <- gsub("\\.", "_", y)

  # Check if y exists in dataset columns
  if (!(y %in% colnames(data))) {
    stop("y must match one data input variable")
  }

  # Check if y column is numeric
  if (!is.numeric(data[[y]])) {
    stop("y column class must be numeric")
  }

  # Define x as explanatory variables (all except y)
  x <- setdiff(colnames(data), y)

  # Check if dataset has more than 1 million rows
  if (nrow(data) > 1e6) {
    stop("Input dataset must not exceed one million rows")
  }

  # Return processed data, y, and x
  return(list(
    data = data,
    y = y,
    x = x
  ))
}
