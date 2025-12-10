split_default_data <- function(data, split) {
  index <- sample(seq_len(nrow(data)), split$train * 0.01 * nrow(data))
  train <- data[index, ]
  test <- data[-index, ]

  list(
    data_train = train,
    data_test = test
  )
}

# prepare_data_for_models <- function(data, split, session = shiny::getDefaultReactiveDomain()) {
#   split_function <- split_default_data
  
#   # Default split if not provided
#   if (missing(split)) split <- list(train = 70)
  
#   split_output <- split_function(data, split)
#   data_train <- data.table(split_output$data_train)
#   data_test  <- data.table(split_output$data_test)

#   # Track columns that were converted
#   converted_cols <- c()
  
#   for (col in colnames(data_train)) {
#     # Check if train column is unsupported type
#     if (!is.numeric(data_train[[col]]) &&
#         !is.integer(data_train[[col]]) &&
#         !is.factor(data_train[[col]]) &&
#         !is.ordered(data_train[[col]])) {
      
#       # Convert train column to factor
#       data_train[[col]] <- as.factor(data_train[[col]])
#       converted_cols <- c(converted_cols, col)
#     }
    
#     # Apply the same conversion to test column if it exists
#     if (col %in% colnames(data_test)) {
#       if (col %in% converted_cols) {
#         data_test[[col]] <- as.factor(data_test[[col]])
#       }
#     }
#   }

#   # Show SweetAlert if any columns were converted
#   if (length(converted_cols) > 0) {
#     show_alert(
#       session = session,
#       title = "Data sanitized",
#       text = paste0(
#         "The following columns were converted to factors to be compatible with mlr:\n",
#         paste(converted_cols, collapse = ", ")
#       ),
#       type = "warning"
#     )
#   }

#   list(
#     data_train = data_train,
#     data_test  = data_test
#   )
# }

prepare_data_for_models <- function(
  data,
  split = list(train = 70),
  target_col = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  
  # --- split train/test ---
  split_output <- split_default_data(data, split)
  data_train <- data.table::as.data.table(split_output$data_train)
  data_test  <- data.table::as.data.table(split_output$data_test)
  
  # --- sanitize columns ---
  for (col in colnames(data_train)) {
    if (!is.numeric(data_train[[col]]) && !is.integer(data_train[[col]])) {
      data_train[[col]] <- as.factor(data_train[[col]])
      data_test[[col]]  <- as.factor(data_test[[col]])
    }
  }
  
  # --- encode train ---
  if (!is.null(target_col)) {
    y_train <- data_train[[target_col]]
    x_train <- data_train[, setdiff(colnames(data_train), target_col), with = FALSE]
    x_train_mm <- model.matrix(~ . -1, data = x_train)
    data_train_encoded <- cbind(as.data.table(x_train_mm), !!target_col := y_train)
    # encode test
    y_test <- data_test[[target_col]]
    x_test <- data_test[, setdiff(colnames(data_test), target_col), with = FALSE]
    x_test_mm <- model.matrix(~ . -1, data = x_test)
    data_test_encoded <- cbind(as.data.table(x_test_mm), !!target_col := y_test)

  } else {
    data_train_encoded <- as.data.table(model.matrix(~ . -1, data = data_train))
    data_test_encoded  <- as.data.table(model.matrix(~ . -1, data = data_test))
  }
  # # --- feedback ---
  # non_numeric <- colnames(data_train)[!sapply(data_train, is.numeric)]
  # if (length(non_numeric) > 0) {
  #   show_alert(
  #     session = session,
  #     title = "Data encoded",
  #     text = paste0(
  #       "Non-numeric columns were encoded for model training:\n",
  #       paste(non_numeric, collapse = ", ")
  #     ),
  #     type = "info"
  #   )
  # }
  
  list(
    data_train =  as.data.frame(data_train),
    data_test  =  as.data.frame(data_test),
    data_train_encoded =  as.data.frame(data_train_encoded),
    data_test_encoded =  as.data.frame(data_test_encoded)
  )
}
