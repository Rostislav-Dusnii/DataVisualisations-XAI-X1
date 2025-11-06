# =============================================================================
# Helper Functions
# =============================================================================
# Shared utility functions used across multiple modules.
# =============================================================================

#' Format simple markdown-ish text to HTML
#'
#' Converts basic markdown formatting to HTML for display in Shiny.
#'
#' @param txt Character string with markdown-like formatting
#' @return Character string with HTML formatting
#' @examples
#' markdownify("Hello\n- Item 1\n- Item 2")
markdownify <- function(txt) {
  txt <- gsub("\n\\- ", "<br>• ", txt)  # Convert list items
  txt <- gsub("\n\n", "<br><br>", txt)  # Double line breaks
  txt <- gsub("\n", "<br>", txt)         # Single line breaks
  txt
}

#' Call OpenAI Chat Completion API
#'
#' Makes a direct API call to OpenAI's chat completion endpoint.
#' Uses httr2 for stability across package versions.
#'
#' @param system_prompt System role prompt (sets AI behavior)
#' @param user_prompt User message/question
#' @param model OpenAI model name (default: gpt-4o-mini)
#' @param temperature Temperature for generation, 0-1 (default: 0.3)
#' @return Character string with AI response
#' @examples
#' gpt_complete("You are helpful", "What is 2+2?")
gpt_complete <- function(system_prompt, user_prompt, model = "gpt-4o-mini", temperature = 0.3) {
  # Build API request
  req <- httr2::request("https://api.openai.com/v1/chat/completions") |>
    httr2::req_headers(
      Authorization = paste("Bearer", Sys.getenv("OPENAI_API_KEY")),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(list(
      model = model,
      temperature = temperature,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user",   content = user_prompt)
      )
    ), auto_unbox = TRUE)

  # Perform request and extract response
  resp <- httr2::req_perform(req) |> httr2::resp_body_json()

  # Safely extract response text
  tryCatch(
    resp$choices[[1]]$message$content,
    error = function(e) "Sorry, I couldn't generate a reply."
  )
}
