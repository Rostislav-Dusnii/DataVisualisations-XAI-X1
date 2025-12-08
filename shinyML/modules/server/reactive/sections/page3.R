observeEvent(input$chat_user_input, {
  user_question <- input$chat_user_input
  req(user_question)

  all_models <- tryCatch(model_training_results()$trained_models, error = function(e) NULL)

  context_parts <- c()

  if (!is.null(all_models) && length(all_models) > 0) {
    context_parts <- c(context_parts, paste0(
      "\n[Trained Models Overview]\n",
      "Total models trained: ", length(all_models), "\n",
      "Model names: ", paste(names(all_models), collapse = ", "), "\n"
    ))

    for (model_name in names(all_models)) {
      model_obj <- all_models[[model_name]]
      context_parts <- c(context_parts, paste0(
        "\n[Model: ", model_name, "]\n",
        "Framework: ", if (!is.null(model_obj$params$framework)) model_obj$params$framework else "unknown", "\n"
      ))
    }

    ctx <- tryCatch(model_context(), error = function(e) NULL)
    if (!is.null(ctx)) {
      context_parts <- c(context_parts, paste0(
        "\n[Dataset Information]\n",
        "Target: ", ctx$target, "\n",
        "Features: ", ctx$features, "\n",
        "Training samples: ", ctx$n_train, "\n",
        "Test samples: ", ctx$n_test
      ))
    }

    xai <- tryCatch(xai_payload(), error = function(e) NULL)
    if (!is.null(xai) && !is.null(xai$explainer)) {
      context_parts <- c(context_parts, paste0(
        "\n[Currently Selected Model for XAI]\n",
        "Model: ", xai$model_label, "\n",
        "Arena.drwhy visualizations available on Page 2"
      ))
    }
  }

  if (length(context_parts) > 0) {
    full_input <- paste0(paste(context_parts, collapse = "\n"), "\n\nUser question: ", user_question)
  } else {
    full_input <- paste0(
      "[No model trained yet - please train a model on Page 1 first]\n\n",
      "User question: ", user_question
    )
  }

  api_key <- Sys.getenv("OPENAI_API_KEY")
  if (api_key == "") {
    shinychat::chat_append("chat", "OpenAI API key is missing. Set OPENAI_API_KEY in your environment.", session = session)
    return()
  }

  tryCatch({
    response <- httr2::request("https://api.openai.com/v1/chat/completions") |>
      httr2::req_headers(
        "Authorization" = paste("Bearer", api_key),
        "Content-Type" = "application/json"
      ) |>
      httr2::req_body_json(list(
        model = "gpt-4o-mini",
        temperature = 0.3,
        messages = list(
          list(role = "system", content = "You are an AI assistant specialized in explaining machine learning models and XAI (Explainable AI) visualizations. You help users understand feature importance, SHAP values, partial dependence plots, and other model explanations from Arena/ModelStudio. When explaining SHAP values, clarify that positive values push predictions higher and negative values push them lower. Be clear, accurate, and helpful."),
          list(role = "user", content = full_input)
        )
      )) |>
      httr2::req_timeout(20) |>
      httr2::req_perform() |>
      httr2::resp_body_json()

    ai_response <- response$choices[[1]]$message$content
    shinychat::chat_append("chat", ai_response, role = "assistant", session = session)

  }, error = function(e) {
    shinychat::chat_append("chat", paste("Error:", e$message), role = "assistant", session = session)
  })
})
