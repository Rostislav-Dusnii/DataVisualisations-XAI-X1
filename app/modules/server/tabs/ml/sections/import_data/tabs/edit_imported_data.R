source_dir(PATH_IMPORT_DATA_UTILS)

updated_data <- update_variables_server_2(
    id = "vars",
    data = reactive({ current_dataset$data }),
    return_data_on_init = FALSE
)

observeEvent(updated_data(), {
    new_data = updated_data()
    if (!is.null(new_data)) {
    # New dataset uploaded → process it
    process_and_update(new_data, current_dataset$title %||% "Imported dataset")
    } else {
    # fallback to default
    process_and_update(default_data, default_title)
    }
})