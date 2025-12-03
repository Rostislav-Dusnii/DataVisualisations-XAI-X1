page2 <- function() {
  section <- tags$div(
    style = "padding: 40px;",
    h1("Page 2", style = "color: #5e72e4;"),
    h3("Welcome to Page 2"),
    p("Bla bla"),
    tags$hr(),
  )

  list(section = section)
}
