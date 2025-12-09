page3 <- function() {
  section <- tagList(
    tags$div(
      style = "padding: 20px;",
      h2("Chatbot"),
      tags$p("Ask questions about your trained models and their explanations."),
      shinychat::chat_ui("chat", height = "600px")
    )
  )

  list(section = section)
}
