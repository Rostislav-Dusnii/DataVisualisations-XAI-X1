
SWITCH_KEYWORDS <- c("switch model", "change model", "different model", "another model", "other model")

observeEvent(input$chat_user_input, {
  user_question <- input$chat_user_input
  req(user_question)

  all_models <- tryCatch(model_training_results()$trained_models, error = function(e) NULL)

  if (is.null(all_models) || length(all_models) == 0) {
    send_chat_message("No models have been trained yet. Please go to Page 1 and train a model first.")
    return()
  }

  model_names <- sapply(all_models, function(m) m$name)
  current_model_count <- length(all_models)

  wants_switch <- any(sapply(SWITCH_KEYWORDS, function(kw) grepl(kw, tolower(user_question))))
  new_models_available <- check_new_models_available(current_model_count)

  if (wants_switch || (new_models_available && !chat_xai_results$awaiting_model_selection)) {
    prompt_model_selection(model_names, new_models_available, if (wants_switch) NULL else user_question)
    return()
  }

  if (chat_xai_results$awaiting_model_selection) {
    handle_model_selection(user_question, model_names, current_model_count)
    return()
  }

  if (is.null(chat_xai_results$var_importance)) {
    if (!auto_generate_xai(model_names, current_model_count, user_question)) return()
  }

  process_xai_question(user_question, session)
})

send_chat_message <- function(message, role = "assistant") {
  shinychat::chat_append("chat", message, role = role, session = session)
}

check_new_models_available <- function(current_count) {
  !is.null(chat_xai_results$selected_model_idx) &&
    !is.null(chat_xai_results$model_count_at_generation) &&
    current_count > chat_xai_results$model_count_at_generation
}

prompt_model_selection <- function(model_names, new_models_available, pending_question) {
  chat_xai_results$awaiting_model_selection <- TRUE
  chat_xai_results$pending_question <- pending_question

  model_list <- paste(sapply(seq_along(model_names), function(i) {
    current_marker <- if (!is.null(chat_xai_results$selected_model_idx) && i == chat_xai_results$selected_model_idx) " (current)" else ""
    paste0(i, ". ", model_names[i], current_marker)
  }), collapse = "\n")

  msg <- if (new_models_available) {
    paste0("I noticed you've trained new models! Which model would you like me to explain?\n\n", model_list, "\n\nPlease type the number or name of the model.")
  } else {
    paste0("Which model would you like me to explain?\n\n", model_list, "\n\nPlease type the number or name of the model.")
  }

  send_chat_message(msg)
}

handle_model_selection <- function(user_input, model_names, current_model_count) {
  selected_idx <- parse_model_selection(user_input, model_names)

  if (is.null(selected_idx)) {
    send_chat_message("I didn't understand your selection. Please type a number (1, 2, etc.) or the model name.")
    return()
  }

  chat_xai_results$awaiting_model_selection <- FALSE
  showNotification(paste("Generating explanations for", model_names[selected_idx], "..."), type = "message", duration = 3)

  success <- generate_xai_for_model(selected_idx)

  if (success) {
    chat_xai_results$model_count_at_generation <- current_model_count
    original_question <- chat_xai_results$pending_question
    chat_xai_results$pending_question <- NULL

    if (!is.null(original_question)) {
      send_chat_message(paste("Using", model_names[selected_idx], "model. Now answering your question..."))
      process_xai_question(original_question, session)
    } else {
      send_chat_message(paste("XAI explanations generated for", model_names[selected_idx], ". You can now ask questions about the model!"))
    }
  } else {
    send_chat_message("Sorry, I couldn't generate explanations for that model. Please try another one.")
  }
}

parse_model_selection <- function(user_input, model_names) {
  trimmed <- trimws(user_input)

  if (grepl("^[0-9]+$", trimmed)) {
    idx <- as.integer(trimmed)
    if (idx >= 1 && idx <= length(model_names)) return(idx)
  }

  for (i in seq_along(model_names)) {
    if (grepl(model_names[i], user_input, ignore.case = TRUE)) return(i)
  }

  NULL
}


auto_generate_xai <- function(model_names, current_model_count, user_question) {
  if (length(model_names) == 1) {
    showNotification("Generating explanations...", type = "message", duration = 3)
    success <- generate_xai_for_model(1)

    if (success) {
      chat_xai_results$model_count_at_generation <- current_model_count
      return(TRUE)
    }

    err_msg <- if (!is.null(chat_xai_results$last_error)) {
      paste("Sorry, I couldn't generate explanations for the model. Error:", chat_xai_results$last_error)
    } else {
      "Sorry, I couldn't generate explanations for the model."
    }
    send_chat_message(err_msg)
    return(FALSE)
  }

  chat_xai_results$awaiting_model_selection <- TRUE
  chat_xai_results$pending_question <- user_question

  model_list <- paste(sapply(seq_along(model_names), function(i) paste0(i, ". ", model_names[i])), collapse = "\n")
  send_chat_message(paste0(
    "You have multiple trained models. Which one would you like me to explain?\n\n",
    model_list,
    "\n\nPlease type the number or name of the model you'd like to explore."
  ))

  FALSE
}
