library(shiny)
library(bslib)
library(dotenv)
library(httr2)
library(shinychat)
library(argonDash)
library(argonR)
library(dygraphs)
library(data.table)
library(ggplot2)
library(shinycssloaders)
library(sparklyr)
library(dplyr)
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
library(DALEX)
library(modelStudio)
source("R/xai_helpers.R")
source("R/custom_header.R")
source("shinyML/modules/helpers.R")
source_dir("shinyML/modules/server")

ui <- argonDashPage(
  useShinyjs(),
  title = "ML Training & XAI",
  description = "Train your own model with XAI",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")
  ),
  header = custom_header(),
  body = argonDashBody(uiOutput("shinyML_body")),
  footer = uiOutput("shinyML_footer")
)

server <- function(input, output, session) {
  h2o::h2o.init()


  data <- iris
  data_process_result <- process_input_data(data)
  data <- data_process_result$data
  available_variables <- data_process_result$available_variables

  shared_env <- list2env(list(
    input = input,
    output = output,
    session = session,
    data = data,
    available_variables = available_variables
  ))

  dates_variable_list <- reactive({
    req(data)
    get_date_columns(data)
  })

  target <- reactiveValues(value = NA)
  features <- reactiveValues(list = list())

  old_wd <- getwd()
  setwd("shinyML")
  source_dir("modules/server/reactive/sections", local = shared_env)
  source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
  source_dir("modules/server/reactive/sections/import_data/sidebar", local = shared_env, recursive = TRUE)
  source_dir("modules/server/reactive/sections/explore_results", local = shared_env)
  source_dir("modules/server/reactive/sections/train_models", local = shared_env)
  setwd(old_wd)

  ui_parts_cached <- NULL

  get_ui_parts <- function() {
    if (is.null(ui_parts_cached)) {
      old_wd <- getwd()
      setwd("shinyML")
      on.exit(setwd(old_wd))

      source("modules/ui.R")
      ui_parts_cached <<- import_UI(data = data)
    }
    ui_parts_cached
  }

  observeEvent(input$navbar_switch, {
    session$sendCustomMessage("switch_page", input$navbar_switch)
  })

  output$shinyML_body <- renderUI({
    ui_parts <- get_ui_parts()
    ui_parts$main
  })

  output$shinyML_footer <- renderUI({
    ui_parts <- get_ui_parts()
    ui_parts$footer
  })
}

shinyApp(ui = ui, server = server)
