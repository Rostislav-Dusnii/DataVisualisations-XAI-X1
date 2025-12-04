gpt_complete <- function(system_prompt, user_prompt, model = "gpt-4o-mini", temperature = 0.3) {
  api_key <- Sys.getenv("OPENAI_API_KEY")
  if (api_key == "") {
    stop("OPENAI_API_KEY environment variable not set")
  }

  response <- httr2::request("https://api.openai.com/v1/chat/completions") |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(list(
      model = model,
      temperature = temperature,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user", content = user_prompt)
      )
    )) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  response$choices[[1]]$message$content
}

observeEvent(input$chat_user_input, {
  user_question <- input$chat_user_input
  req(user_question)

  ctx <- model_context()
  xai <- xai_payload()

  context_text <- if (!is.null(ctx)) {
    paste0(
      "You are helping explain a machine learning model.\n\n",
      "Model Information:\n",
      "- Dataset: ", ctx$dataset, "\n",
      "- Target variable: ", ctx$target, "\n",
      "- Model type: ", ctx$model_type, "\n",
      "- Features: ", ctx$features, "\n",
      "- Training samples: ", ctx$n_train, "\n",
      "- Test samples: ", ctx$n_test, "\n",
      "- Observations explained: ", ctx$observations_explained, "\n"
    )
  } else {
    "Model context not available yet. Please train a model first.\n"
  }

  arena_text <- if (!is.null(xai) && !is.null(xai$arena_json)) {
    paste0("Arena/ModelStudio payload detected for model: ", xai$model_label, ". ",
           "Contains XAI panels (feature importance, ceteris paribus, etc.).")
  } else {
    "Arena/ModelStudio payload not yet available."
  }

  prompt_text <- paste0(
    context_text, "\n", arena_text, "\n\n",
    "User question: ", user_question
  )

  tryCatch({
    ai_response <- gpt_complete(
      system_prompt = paste0(
        "You are an AI assistant helping explain machine learning models and their predictions. ",
        "Use the provided model information to answer questions. ",
        "Be clear, accurate, and helpful. If you don't have specific information, say so."
      ),
      user_prompt = prompt_text,
      model = "gpt-4o-mini",
      temperature = 0.3
    )
    shinychat::chat_append("chat", ai_response, session = session)
  }, error = function(e) {
    shinychat::chat_append("chat", paste("Error:", e$message), session = session)
  })
})
