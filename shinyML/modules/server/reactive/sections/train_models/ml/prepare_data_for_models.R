source("modules/server/reactive/sections/train_models/ml/utils/get_data_split_strategy.R", local = shared_env)

prepare_data_for_models <- function(data, split, session = shiny::getDefaultReactiveDomain()) {
  split_function <- get_data_split_strategy()
  
  # Default split if not provided
  if (missing(split)) split <- list(train = 70)
  
  split_output <- split_function(data, split)
  data_train <- data.table(split_output$data_train)
  data_test  <- data.table(split_output$data_test)

  # Track columns that were converted
  converted_cols <- c()
  
  for (col in colnames(data_train)) {
    # Check if train column is unsupported type
    if (!is.numeric(data_train[[col]]) &&
        !is.integer(data_train[[col]]) &&
        !is.factor(data_train[[col]]) &&
        !is.ordered(data_train[[col]])) {
      
      # Convert train column to factor
      data_train[[col]] <- as.factor(data_train[[col]])
      converted_cols <- c(converted_cols, col)
    }
    
    # Apply the same conversion to test column if it exists
    if (col %in% colnames(data_test)) {
      if (col %in% converted_cols) {
        data_test[[col]] <- as.factor(data_test[[col]])
      }
    }
  }

  # Show SweetAlert if any columns were converted
  if (length(converted_cols) > 0) {
    show_alert(
      session = session,
      title = "Data sanitized",
      text = paste0(
        "The following columns were converted to factors to be compatible with mlr:\n",
        paste(converted_cols, collapse = ", ")
      ),
      type = "warning"
    )
  }

  list(
    data_train = data_train,
    data_test  = data_test
  )
}