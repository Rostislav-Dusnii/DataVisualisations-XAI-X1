mod_page1_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      style = "text-align: center; padding: 100px 40px;",
      h1("ML Model Training", style = "color: #2c3e50;"),
      br(), br(),
      ),
      p(style = "color: #95a5a6;",
        "To be implemented."
      )
    )
}


mod_page1_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # just a placeholder for now
    trained_model <- reactiveVal(NULL)
    return(trained_model)
  })
}
