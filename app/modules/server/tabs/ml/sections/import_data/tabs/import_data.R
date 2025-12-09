
imported <- import_file_server(
id = "myid",
# Custom functions to read data
read_fns = list(
    csv = function(file) {
    readr::read_csv(file)
    },
    txt = function(file) {
    readr::read_delim(file, delim = "\t")  
    },
    xls = function(file, sheet, skip, encoding) {
    readxl::read_xls(path = file, sheet = sheet, skip = skip)
    },
    xlsx = function(file, sheet, skip, encoding) {
    readxl::read_xlsx(path = file, sheet = sheet, skip = skip)
    },
    json = function(file) {
    jsonlite::read_json(file, simplifyVector = TRUE)
    }
),
show_data_in = "modal"
)

observe({
    uploaded_data <- imported$data()
    uploaded_name <- imported$name()

    if (!is.null(uploaded_data)) {
    # New dataset uploaded → process it
    process_and_update(uploaded_data, uploaded_name %||% "Imported dataset")
    } else {
    # fallback to default
    process_and_update(default_data, default_title)
    }
})