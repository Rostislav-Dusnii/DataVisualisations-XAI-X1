edit_imported_data <- argonTab(
  tabName = "Edit imported data",
  active = FALSE,
  theme = bslib::bs_theme(version = 5L, preset = "bootstrap"),
  argonRow(
    column(
      width = 12,
      # radioButtons()
      update_variables_ui("vars")
    )
  )
)
