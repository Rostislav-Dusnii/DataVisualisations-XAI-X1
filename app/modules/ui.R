# Load UI components
source_dir(PATH_UI)

# Main Shiny UI layout
ui <- argonDashPage(
  useShinyjs(),
  title = "ML & XAI",
  description = "Train your own model with XAI",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")
  ),
  header = header,
  body = main
  # footer = footer
)
