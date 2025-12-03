page3 <- function() {
  section <- tags$div(
    style = "padding: 40px;",
    h1("Page 3", style = "color: #11cdef;"),
    h3("Welcome to Page 3"),
    p("Blabla"),
    tags$hr(),

  )

  list(section = section)
}
