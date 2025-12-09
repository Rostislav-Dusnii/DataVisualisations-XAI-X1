source_dir(PATH_DATASET_UTILS)
dates_variable_list <- reactive({
    req(current_dataset$data) # ensure data is available
    get_date_columns(current_dataset$data)
})

current_dataset <- reactiveValues(
    data = NA,
    title = NA,
    available_variables = NA
)
target <- reactiveValues(value = NA, results_table_value = NA)
features <- reactiveValues(list = list())


available_targets <- reactive({
  numeric_cols <- sapply(current_dataset$data[, current_dataset$available_variables, with = FALSE], 
                         function(x) is.numeric(x) || is.integer(x))
  setdiff(current_dataset$available_variables[numeric_cols], dates_variable_list())
})
available_features <- reactive({
  target_col <- target$value
  setdiff(current_dataset$available_variables, c(dates_variable_list(), target_col))
})

process_and_update <- function(data, title) {
    data_process_result <- process_input_data(data)
    current_dataset$data <- data_process_result$data
    current_dataset$available_variables <- data_process_result$available_variables
    current_dataset$title <- title
}


default_title <- "Default dataset"
default_data <- iris

process_and_update(default_data, default_title)