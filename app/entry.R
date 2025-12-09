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
library(datamods)
library(shinyFiles)

shinyXAI_app <- function() {
    # Load all required packages
    source("modules/paths.R")
    source(PATH_HELPERS)
    source(PATH_SETTINGS)
    source(PATH_XAI_HELPERS)
    source(PATH_UI_MAIN)
    source(PATH_SERVER_MAIN)

    app <- shiny::shinyApp(
    ui = ui,
    server = server
    )

    return(app)
}


# Launch the app with your dataset
shinyXAI_app()
