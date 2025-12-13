# file upload tab
import_data <- argonTab(
  tabName = "Import data",
  active = TRUE,
  argonRow(
    column(
      width = 12,
      import_file_ui(
        id = "myid",
        file_extensions = c(".csv", ".txt", ".xls", ".xlsx", ".json"),
        layout_params = "inline" # or "dropdown"
      )
    )
  )
)

