page3 <- function() {
  section <- argonDash::argonCard(
    title = "Ask the AI about your model",
    status = "primary",
    icon = icon("comments"),
    width = 12,
    argonDash::argonRow(
      column(
        width = 12,
        tags$p("Pose questions about the trained model and its explanations."),
        shinychat::chat_ui("chat", height = "600px")
      )
    )
  )

  list(section = section)
}
