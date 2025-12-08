# Build vector resuming which Date or POSIXct columns are contained in input dataset
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

process_and_update <- function(data, title) {
    data_process_result <- process_input_data(data)
    current_dataset$data <- data_process_result$data
    current_dataset$available_variables <- data_process_result$available_variables
    current_dataset$title <- title
}

default_title <- "Default dataset"
process_and_update(data, default_title)