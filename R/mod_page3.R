mod_page3_ui <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Ask Questions About the Model"),
    shinychat::chat_ui(ns("chat"), height = "600px")
  )
}

mod_page3_server <- function(id, model_context = reactive(NULL), arena_payload = reactive(NULL)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # handle questions
    observeEvent(input$chat_user_input, {
      user_question <- input$chat_user_input
      req(user_question)

      # get context from page 2
      context <- model_context()
      xai <- arena_payload()

      # context string for AI
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
          " apartment predictions.\n"
        )
      } else {
        context_text <- paste0(
          "Note: Model context not yet available. ",
          "Please visit Page 2 first to see the model visualization.\n"
        )
      }

      arena_text <- if (!is.null(xai) && !is.null(xai$arena_json)) {
        paste0(
          "Arena/ModelStudio payload detected for model: ", xai$model_label, ". ",
          "Contains XAI panels (feature importance, ceteris paribus, etc.)."
        )
      } else {
        "Arena/ModelStudio payload not yet available."
      }

      prompt_text <- paste0(
        context_text,
        "\n", arena_text, "\n\n",
        "User question: ", user_question
      )

      # response
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

        # add response to chat
        shinychat::chat_append("chat", markdownify(ai_response), session = session)

      }, error = function(e) {
        error_msg <- paste("Error:", e$message)
        shinychat::chat_append("chat", error_msg, session = session)
      })
    })
  })
}
