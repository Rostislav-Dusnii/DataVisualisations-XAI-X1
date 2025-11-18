shinyML_regression <- function(data) {
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

  source("modules/ui.R")
  ui_parts <- import_UI(data = data)
  source("modules/server.R")
  server_part <- import_server(data = data)

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

shinyML_regression(data = iris)
