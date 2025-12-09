output$save_models_selection <- renderUI({
  trained_models_list <- model_training_results()$trained_models
  req(!is.null(trained_models_list))

  model_cards <- lapply(names(trained_models_list), function(model_name) {
    model_obj <- trained_models_list[[model_name]]
    display_name <- model_obj$name
    framework <- model_obj$params$framework
    training_time <- if (!is.null(model_obj$time)) model_obj$time else "N/A"

    # Determine card status color
    card_status <- switch(framework, mlr = "success", h2o = "primary", "default")

    # Unique IDs per model
    folder_input_id <- paste0("save_dir_", model_name)
    button_input_id <- paste0("save_", model_name)
    dir_output_id <- paste0("dir_text_", model_name)

    argonCard(
      title = display_name,
      width = 4,
      hover_lift = TRUE,
      shadow = TRUE,
      icon = icon("cogs"),
      status = card_status,
      src = NULL,
      tags$div(
        tags$p(strong("Framework:"), framework),
        tags$p(strong("Training time:"), training_time),
        shinyDirButton("dir", "Choose folder", "Select folder"),
        verbatimTextOutput("dir", placeholder = TRUE),
        actionButton(inputId = button_input_id, label = "Save model", icon = icon("save"), class = "btn-primary btn-block")
      )
    )
  })

  do.call(argonRow, model_cards)
})
