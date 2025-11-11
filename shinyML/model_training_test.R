shinyML_regression <- function(data = data, y) {
  library(shiny)
  library(argonDash)
  library(argonR)
  library(dygraphs)
  library(data.table)
  library(ggplot2)
  library(shinycssloaders)
  library(sparklyr)
  library(dplyr) # or use dplyr::function_name for individual functions
  library(tidyr)
  library(DT)
  library(h2o)
  library(plotly)
  library(shinyWidgets)
  library(shinyjs)
  library(lubridate)

  source("modules/UI.R")
  ui_parts <- import_UI(data = data, y = y)
  source("modules/Server.R")
  server_part <- create_shinyML_Server(data = data, y = y)

  ## ---------------------------------------------------------------------------- LAUNCH APP  -----------------------------------
  # Assembly UI and SERVER sides inside shinyApp
  app <- shiny::shinyApp(
    ui = argonDashPage(
      useShinyjs(),
      title = "ML_training",
      description = "Train your own model",
      header = ui_parts$main,
      footer = ui_parts$footer
    ),
    server = server_part$server
  )
}

shinyML_regression(data = iris, y = "Petal.Width")
