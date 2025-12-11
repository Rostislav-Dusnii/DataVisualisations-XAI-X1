
EXCLUDED_PDP_VARS <- c("Species", "species")

output$chat_current_model_status <- renderUI({
  all_models <- tryCatch(model_training_results()$trained_models, error = function(e) NULL)
  selected_idx <- chat_xai_results$selected_model_idx

  if (is.null(all_models) || length(all_models) == 0) {
    return(tags$div(
      class = "alert alert-info",
      style = "margin-bottom: 15px;",
      tags$strong("No models trained. "),
      "Train a model on Page 1, then come back and ask questions about it."
    ))
  }

  if (is.null(selected_idx)) {
    model_count <- length(all_models)
    return(tags$div(
      class = "alert alert-info",
      style = "margin-bottom: 15px;",
      tags$strong(paste(model_count, if (model_count == 1) "model" else "models", "available. ")),
      "Ask a question to get started - the chatbot will generate explanations automatically."
    ))
  }

  model_obj <- all_models[[selected_idx]]
  tags$div(
    class = "alert alert-success",
    style = "margin-bottom: 15px;",
    tags$strong("Currently explaining: "), model_obj$name,
    tags$span(
      style = "margin-left: 15px; font-size: 0.9em; color: #666;",
      paste("(", length(all_models), "model(s) trained)")
    )
  )
})

output$chat_pdp_variable_selector <- renderUI({
  vi <- chat_xai_results$var_importance
  pdp <- chat_xai_results$partial_dependence
  if (is.null(vi) || is.null(pdp)) return(NULL)

  vi_df <- as.data.frame(vi)
  vars <- unique(vi_df$variable[!vi_df$variable %in% c("_baseline_", "_full_model_")])

  pdp_df <- as.data.frame(pdp$agr_profiles)
  pdp_vars <- unique(pdp_df$`_vname_`)

  numeric_vars <- vars[vars %in% pdp_vars]
  numeric_vars <- numeric_vars[!numeric_vars %in% EXCLUDED_PDP_VARS]

  if (length(numeric_vars) == 0) return(NULL)

  selectInput("chat_pdp_variable", "Variable:",
    choices = numeric_vars,
    selected = numeric_vars[1]
  )
})
