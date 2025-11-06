mod_chat_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header("General GPT Chat"),
      shinychat::chat_mod_ui(ns("chat"))
    )
  )
}

mod_chat_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    req(nzchar(Sys.getenv("OPENAI_API_KEY")))
    client <- ellmer::chat_openai(
      model = "gpt-4o-mini",
      system_prompt = "You are a helpful assistant for an XAI Shiny app. Be concise and accurate."
    )
    shinychat::chat_mod_server("chat", client)
  })
}
