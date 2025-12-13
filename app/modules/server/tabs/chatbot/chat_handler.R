# keywords for model switching 
SWITCH_KEYWORDS <- c("switch model", "change model", "different model", "another model", "other model")

# main chat input handler
observeEvent(input$chat_user_input, {
  user_question <- input$chat_user_input
  req(user_question)

  # get all trained models
  all_models <- tryCatch(model_training_results()$trained_models, error = function(e) NULL)

  # exit early if no models have been trained yet
  if (is.null(all_models) || length(all_models) == 0) {
    send_chat_message("No models have been trained yet. Please go to Page 1 and train a model first.")
    return()
  }

  model_names <- sapply(all_models, function(m) m$name)
  current_model_count <- length(all_models)

  # check if user wants to switch models or if new models were trained since last selection
  wants_switch <- any(sapply(SWITCH_KEYWORDS, function(kw) grepl(kw, tolower(user_question))))
  new_models_available <- check_new_models_available(current_model_count)

  # prompt for model selection if switching requested or new models detected
  if (wants_switch || (new_models_available && !chat_xai_results$awaiting_model_selection)) {
    prompt_model_selection(model_names, new_models_available, if (wants_switch) NULL else user_question)
    return()
  }

  # handle pending model selection from previous prompt
  if (chat_xai_results$awaiting_model_selection) {
    handle_model_selection(user_question, model_names, current_model_count)
    return()
  }

  # auto generate XAI explanations if not yet available
  if (is.null(chat_xai_results$var_importance)) {
    if (!auto_generate_xai(model_names, current_model_count, user_question)) return()
  }

  # process the user's question using the XAI data
  process_xai_question(user_question, session)
})

# helper to send a message to the chat UI
send_chat_message <- function(message, role = "assistant") {
  shinychat::chat_append("chat", message, role = role, session = session)
}

# checks if new models have been trained since XAI was last generated
check_new_models_available <- function(current_count) {
  !is.null(chat_xai_results$selected_model_idx) &&
    !is.null(chat_xai_results$model_count_at_generation) &&
    current_count > chat_xai_results$model_count_at_generation
}

# displays a numbered list of models and prompts user to select one
prompt_model_selection <- function(model_names, new_models_available, pending_question) {
  chat_xai_results$awaiting_model_selection <- TRUE
  chat_xai_results$pending_question <- pending_question

  # build numbered list with current marker for active model
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

# processes user's model selection and generates XAI explanations
handle_model_selection <- function(user_input, model_names, current_model_count) {
  selected_idx <- parse_model_selection(user_input, model_names)

  # ask again if selection wasn't understood
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

    # if user had a pending question, answer it now
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

# parses user input to find which model they selected 
parse_model_selection <- function(user_input, model_names) {
  trimmed <- trimws(user_input)

  # check if input is a number
  if (grepl("^[0-9]+$", trimmed)) {
    idx <- as.integer(trimmed)
    if (idx >= 1 && idx <= length(model_names)) return(idx)
  }

  # check if input matches a model name
  for (i in seq_along(model_names)) {
    if (grepl(model_names[i], user_input, ignore.case = TRUE)) return(i)
  }

  NULL
}


# auto generates XAI for single model, or prompts selection for multiple
auto_generate_xai <- function(model_names, current_model_count, user_question) {
  # if only one model exists, auto select it
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

  # multiple models exist - prompt user to choose
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
