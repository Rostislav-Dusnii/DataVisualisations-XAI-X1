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
  library(stringr)
  library(DT)
  library(h2o)
  library(plotly)
  library(shinyWidgets)
  library(shinyjs)
  library(lubridate)
  library(mlr)
  library(mlr3)
  library(mlr3learners)
  library(datamods)
  library(stringr)
  library(shinyFiles)

  source("modules/ui.R")
  ui_parts <- import_UI(data = data)
  source("modules/server.R")
  server_part <- import_server(data = data)
  # make exported reactives available to outer apps if needed
  assign("shinyML_exports", server_part$exports, envir = .GlobalEnv)

  ## ---------------------------------------------------------------------------- LAUNCH APP  -----------------------------------
  # Assembly UI and SERVER sides inside shinyApp
  app <- shiny::shinyApp(
    ui = argonDashPage(
      useShinyjs(),

      # ---- FIX ARGON MODAL PROBLEM ----
      tags$head(
        tags$style(HTML("
          #dir-modal.fade:not(.show) {
            opacity: 100 !important;
          }
        "))
      ),
      # ---------------------------------

      title = "ML_training",
      description = "Train your own model",
      header = ui_parts$header,
      body = argonDashBody(ui_parts$main),
      footer = ui_parts$footer
    ),
    server = function(input, output, session) {
      server_part$server(input, output, session)
    }
  )
}

shinyML_regression(data = iris)
