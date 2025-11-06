# --- General Chat Module (using ellmer + shinychat) ---

#' General Chat UI
#' @param id Module namespace ID
mod_chat_ui <- function(id) {
  ns <- NS(id)
  shinychat::chat_mod_ui(ns("chat"))
}

#' General Chat Server
#' @param id Module namespace ID
mod_chat_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Create ellmer chat client
    gen_client <- ellmer::chat_openai(
      model = "gpt-4o-mini",
      system_prompt = "You are a presentation coach for data scientists. Give constructive, focused, and practical feedback on titles, structure, and storytelling."
    )

    # Use shinychat module server
    shinychat::chat_mod_server("chat", gen_client)
  })
}
