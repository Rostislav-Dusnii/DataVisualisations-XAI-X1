# =============================================================================
# DeckCheck - 3-Page ML Explainability App
# =============================================================================

# --- Load Libraries ---
library(shiny)
library(bslib)
library(dotenv)
library(httr2)
library(shinychat)
library(r2d3)
library(mlr)
library(DALEXtra)
library(modelStudio)

# --- Load Environment Variables ---
dotenv::load_dot_env(".env")
stopifnot(nzchar(Sys.getenv("OPENAI_API_KEY")))

# --- Source Modules ---
source("R/xai_helpers.R")
source("R/mod_page1.R")
source("R/mod_page2.R")
source("R/mod_page3.R")

# =============================================================================
# UI
# =============================================================================

ui <- page_navbar(
  theme = bs_theme(bootswatch = "flatly"),
  title = "DeckCheck",

  # Page 1: ML Training
  nav_panel(
    "1. Train Models",
    icon = icon("brain"),
    mod_page1_ui("page1")
  ),

  # Page 2: Visualizations
  nav_panel(
    "2. Visualizations",
    icon = icon("chart-line"),
    mod_page2_ui("page2")
  ),

  # Page 3: AI Chatbot
  nav_panel(
    "3. Ask AI",
    icon = icon("comments"),
    mod_page3_ui("page3")
  )
)

# =============================================================================
# Server
# =============================================================================

server <- function(input, output, session) {
  # Page 1: Train models (placeholder)
  trained_model <- mod_page1_server("page1")

  # Page 2: Show visualizations only (returns model context)
  model_context <- mod_page2_server("page2")

  # Page 3: Chatbot that uses model context from Page 2
  mod_page3_server("page3", model_context = model_context)
}

# =============================================================================
# Run App
# =============================================================================

shinyApp(ui = ui, server = server)
