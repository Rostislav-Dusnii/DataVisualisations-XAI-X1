# =============================================================================
# Page 3 - AI Chatbot
# =============================================================================

#' Page 3 UI - AI Chatbot
#' @param id Module namespace ID
mod_page3_ui <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Ask Questions About the Model"),
    p(class = "text-muted",
      "Use this AI chatbot to ask questions about the model visualizations from Page 2."
    ),
    p("Examples: 'What does this model predict?', 'Which features are most important?', ",
      "'How accurate is the model?', 'Explain the predictions'"),
    hr(),
    shinychat::chat_ui(ns("chat"), height = "600px")
  )
}

#' Page 3 Server - AI Chatbot
#' @param id Module namespace ID
#' @param model_context Reactive containing model information from Page 2
mod_page3_server <- function(id, model_context = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Handle user questions
    observeEvent(input$chat_user_input, {
      user_question <- input$chat_user_input
      req(user_question)

      # Get model context from Page 2
      context <- model_context()

      # Build context string for AI
      if (!is.null(context)) {
        context_text <- paste0(
          "You are helping explain a machine learning model.\n\n",
          "Model Information:\n",
          "- Dataset: ", context$dataset, "\n",
          "- Target variable: ", context$target, "\n",
          "- Model type: ", context$model_type, "\n",
          "- Features: ", context$features, "\n",
          "- Training samples: ", context$n_train, "\n",
          "- Test samples: ", context$n_test, "\n",
          "- The visualization shows explanations for ", context$observations_explained,
          " apartment predictions.\n\n",
          "User question: ", user_question
        )
      } else {
        context_text <- paste0(
          "Note: Model context not yet available. ",
          "Please visit Page 2 first to see the model visualization.\n\n",
          "User question: ", user_question
        )
      }

      # Get AI response
      tryCatch({
        ai_response <- gpt_complete(
          system_prompt = paste0(
            "You are an AI assistant helping explain machine learning models and their predictions. ",
            "Use the provided model information to answer questions. ",
            "Be clear, accurate, and helpful. If you don't have specific information, say so."
          ),
          user_prompt = context_text,
          model = "gpt-4o-mini",
          temperature = 0.3
        )

        # Add response to chat
        shinychat::chat_append("chat", markdownify(ai_response), session = session)

      }, error = function(e) {
        error_msg <- paste("Error:", e$message)
        shinychat::chat_append("chat", error_msg, session = session)
      })
    })
  })
}
