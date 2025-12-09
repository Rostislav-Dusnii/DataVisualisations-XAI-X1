library(shiny)
library(datamods)

ui <- fluidPage(
  tags$h3("Import data from a file"),
  fluidRow(
    column(
      width = 4,
      import_file_ui(
        id = "myid",
        file_extensions = c(".csv", ".txt", ".xls", ".xlsx", ".json"),
        layout_params = "inline" # or "dropdown"
      )
    ),
    column(
      width = 8,
      tags$b("Import status:"),
      verbatimTextOutput(outputId = "status"),
      tags$b("Name:"),
      verbatimTextOutput(outputId = "name"),
      tags$b("Code:"),
      verbatimTextOutput(outputId = "code"),
      tags$b("Data:"),
      verbatimTextOutput(outputId = "data")
    )
  )
)

server <- function(input, output, session) {

  imported <- import_file_server(
    id = "myid",
    # Custom functions to read data
    read_fns = list(
        csv = function(file) {
        readr::read_csv(file)
        },
        txt = function(file) {
        readr::read_delim(file, delim = "\t")  
        },
        xls = function(file, sheet, skip, encoding) {
        readxl::read_xls(path = file, sheet = sheet, skip = skip)
        },
        xlsx = function(file, sheet, skip, encoding) {
        readxl::read_xlsx(path = file, sheet = sheet, skip = skip)
        },
        json = function(file) {
        jsonlite::read_json(file, simplifyVector = TRUE)
        }
    ),
    show_data_in = "modal"
  )

  output$status <- renderPrint({
    imported$status()
  })
  output$name <- renderPrint({
    imported$name()
  })
  output$code <- renderPrint({
    imported$code()
  })
  output$data <- renderPrint({
    imported$data()
  })

}

if (interactive())
  shinyApp(ui, server)

shinyApp(ui, server)
