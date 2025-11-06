library(shiny)
library(bslib)
library(dotenv)
library(httr2)
library(shinychat)
library(r2d3)
library(mlr)
library(DALEXtra)
library(modelStudio)

dotenv::load_dot_env(".env")
if (!nzchar(Sys.getenv("OPENAI_API_KEY"))) {
  warning("OPENAI_API_KEY not found in .env file. Page 3 chatbot will not work.")
}

source("R/xai_helpers.R")
source("R/mod_page1.R")
source("R/mod_page2.R")
source("R/mod_page3.R")

ui <- page_navbar(
  theme = bs_theme(bootswatch = "flatly"),
  title = "DeckCheck",

  nav_panel(
    "1. Train Models",
    mod_page1_ui("page1")
  ),

  nav_panel(
    "2. Visualizations",
    mod_page2_ui("page2")
  ),

  nav_panel(
    "3. Ask AI",
    mod_page3_ui("page3")
  )
)

server <- function(input, output, session) {
  trained_model <- mod_page1_server("page1")

  model_context <- mod_page2_server("page2")

  mod_page3_server("page3", model_context = model_context)
}


shinyApp(ui = ui, server = server)
