source_dir(PATH_DATASET_UTILS)

# current dataset state
current_dataset <- reactiveValues(
    data = NA,
    title = NA,
    available_variables = NA,
    dates_variable_list = list(),
    id_columns = list()
)

# target and feature selection
target <- reactiveValues(value = NA, results_table_value = NA)
features <- reactiveValues(list = list())

# numeric columns available as targets
available_targets <- reactive({
  numeric_cols <- sapply(current_dataset$data[, current_dataset$available_variables, with = FALSE],
                         function(x) is.numeric(x) || is.integer(x))
  setdiff(current_dataset$available_variables[numeric_cols], current_dataset$dates_variable_list)
})

# columns available as features (excludes target and dates)
available_features <- reactive({
  target_col <- target$value
  setdiff(current_dataset$available_variables, c(current_dataset$dates_variable_list, target_col))
})

# processes uploaded data and updates dataset state
process_and_update <- function(data, title) {
    data_process_result <- process_input_data(data)
    current_dataset$data <- data_process_result$data
    current_dataset$available_variables <- data_process_result$available_variables
    current_dataset$title <- title
    current_dataset$dates_variable_list <- data_process_result$date_columns
    current_dataset$id_columns <- data_process_result$id_columns
}

# default dataset
default_title <- "Default dataset"
default_data <- iris

process_and_update(default_data, default_title)

# train/test split
split <- list(train = 70)
train_test_data <- reactive({
  prepare_data_for_models(current_dataset$data, split, target$value, features$list)
})
