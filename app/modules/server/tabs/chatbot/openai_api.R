
OPENAI_MODEL <- "gpt-4o-mini"
OPENAI_TEMPERATURE <- 0.3
OPENAI_TIMEOUT <- 30

process_xai_question <- function(user_question, session) {
  vi_data <- chat_xai_results$var_importance
  pdp_data <- chat_xai_results$partial_dependence
  all_models <- tryCatch(model_training_results()$trained_models, error = function(e) NULL)

  context_parts <- build_context(all_models, vi_data, pdp_data)
  valid_vars <- extract_valid_vars(vi_data)
  full_input <- paste0(paste(context_parts, collapse = "\n"), "\n\nUser question: ", user_question)

  api_key <- Sys.getenv("OPENAI_API_KEY")
  if (api_key == "") {
    shinychat::chat_append("chat", "OpenAI API key is missing. Set OPENAI_API_KEY in your environment.", session = session)
    return()
  }

  tryCatch({
    response <- call_openai_api(api_key, build_system_prompt(valid_vars), full_input)
    ai_response <- response$choices[[1]]$message$content
    ai_response <- handle_visualization_commands(ai_response, user_question, valid_vars, session)
    shinychat::chat_append("chat", ai_response, role = "assistant", session = session)
  }, error = function(e) {
    shinychat::chat_append("chat", paste("Error:", e$message), role = "assistant", session = session)
  })
}


build_context <- function(all_models, vi_data, pdp_data) {
  context_parts <- c()

  if (!is.null(all_models) && !is.null(chat_xai_results$selected_model_idx)) {
    model_obj <- all_models[[chat_xai_results$selected_model_idx]]
    context_parts <- c(context_parts, paste0("\n[Current Model]\nModel: ", model_obj$name))

    ctx <- tryCatch(model_context(), error = function(e) NULL)
    if (!is.null(ctx)) {
      context_parts <- c(context_parts, paste0(
        "\n[Dataset]\n",
        "Target: ", ctx$target, "\n",
        "Features: ", ctx$features, "\n",
        "Training samples: ", ctx$n_train, ", Test samples: ", ctx$n_test
      ))
    }
  }

  if (!is.null(vi_data)) {
    vi_df <- as.data.frame(vi_data)
    vi_df <- vi_df[!vi_df$variable %in% c("_baseline_", "_full_model_"), ]
    vi_agg <- aggregate(dropout_loss ~ variable, data = vi_df, FUN = mean)
    vi_agg <- vi_agg[order(vi_agg$dropout_loss, decreasing = TRUE), ]

    vi_text <- paste(apply(vi_agg, 1, function(row) {
      paste0(row["variable"], ": ", round(as.numeric(row["dropout_loss"]), 4))
    }), collapse = "\n")

    context_parts <- c(context_parts, paste0(
      "\n[Variable Importance - Permutation-based]\n",
      "Higher dropout loss = more important feature\n",
      vi_text
    ))
  }

  if (!is.null(pdp_data)) {
    pdp_vars <- unique(as.data.frame(pdp_data$agr_profiles)$`_vname_`)
    context_parts <- c(context_parts, paste0(
      "\n[Partial Dependence Profiles]\n",
      "Available for variables: ", paste(pdp_vars, collapse = ", "), "\n",
      "Currently showing: ", input$chat_pdp_variable
    ))
  }

  context_parts
}

extract_valid_vars <- function(vi_data) {
  if (is.null(vi_data)) return(c())
  vi_df <- as.data.frame(vi_data)
  unique(vi_df$variable[!vi_df$variable %in% c("_baseline_", "_full_model_")])
}

call_openai_api <- function(api_key, system_prompt, user_input) {
  httr2::request("https://api.openai.com/v1/chat/completions") |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(list(
      model = OPENAI_MODEL,
      temperature = OPENAI_TEMPERATURE,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user", content = user_input)
      )
    )) |>
    httr2::req_timeout(OPENAI_TIMEOUT) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

build_system_prompt <- function(valid_vars) {
  paste0(
    "You are an AI assistant specialized in explaining XAI (Explainable AI) visualizations. ",
    "You have access to:\n",
    "1. Variable Importance plot - shows which features matter most (higher dropout loss = more important)\n",
    "2. Partial Dependence Plot (PDP) - shows how a feature affects predictions on average\n\n",
    "IMPORTANT - Visualization commands:\n",
    "- ONLY use [HIGHLIGHT:variable_name] when the USER SPECIFICALLY ASKS about a particular variable\n",
    "- ONLY use [SHOW_PDP:variable_name] when the USER SPECIFICALLY ASKS about a variable's effect or PDP\n",
    "- Do NOT use these commands when giving general overviews or when YOU mention variables\n",
    "- Valid variable names are: ", paste(valid_vars, collapse = ", "), "\n\n",
    "Example: If user asks 'tell me about Petal.Length', end with [HIGHLIGHT:Petal.Length][SHOW_PDP:Petal.Length]\n",
    "Example: If user asks 'explain the model', do NOT use any commands - just explain.\n\n",
    "Guidelines:\n",
    "- Reference specific values from the data provided\n",
    "- Be concise but informative\n",
    "- Explain in simple terms what the visualizations mean"
  )
}

handle_visualization_commands <- function(ai_response, user_question, valid_vars, session) {
  highlight_found <- FALSE
  pdp_found <- FALSE

  if (grepl("\\[HIGHLIGHT:", ai_response)) {
    var_name <- sub(".*\\[HIGHLIGHT:([^]]+)\\].*", "\\1", ai_response)
    chat_xai_results$highlight_var <- var_name
    ai_response <- gsub("\\[HIGHLIGHT:[^]]+\\]", "", ai_response)
    highlight_found <- TRUE
  }

  if (grepl("\\[SHOW_PDP:", ai_response)) {
    var_name <- sub(".*\\[SHOW_PDP:([^]]+)\\].*", "\\1", ai_response)
    updateSelectInput(session, "chat_pdp_variable", selected = var_name)
    ai_response <- gsub("\\[SHOW_PDP:[^]]+\\]", "", ai_response)
    pdp_found <- TRUE
  }

  if (!highlight_found || !pdp_found) {
    mentioned_var <- detect_variable_in_question(user_question, valid_vars)

    if (!is.null(mentioned_var)) {
      if (!highlight_found) chat_xai_results$highlight_var <- mentioned_var
      if (!pdp_found) updateSelectInput(session, "chat_pdp_variable", selected = mentioned_var)
    } else if (!highlight_found) {
      chat_xai_results$highlight_var <- NULL
    }
  }

  trimws(ai_response)
}

detect_variable_in_question <- function(question, valid_vars) {
  for (v in valid_vars) {
    if (grepl(paste0("\\b", v, "\\b"), question, ignore.case = TRUE)) {
      return(v)
    }
  }

  question_lower <- tolower(question)
  for (v in valid_vars) {
    v_parts <- unlist(strsplit(tolower(v), "\\."))
    if (length(v_parts) >= 2) {
      pattern <- paste(v_parts, collapse = ".*")
      if (grepl(pattern, question_lower)) return(v)

      pattern_rev <- paste(rev(v_parts), collapse = ".*")
      if (grepl(pattern_rev, question_lower)) return(v)
    }
  }

  NULL
}
