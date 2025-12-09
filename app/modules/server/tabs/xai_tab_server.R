output$model_selector <- renderUI({
  tm <- tryCatch(model_training_results()[["trained_models"]], error = function(e) NULL)

  if (is.null(tm) || length(tm) == 0) {
    return(tags$p("No models trained yet", style = "color: #888;"))
  }

  model_names <- sapply(tm, function(m) m$name)
  selectInput("selected_model", "Select Model:",
              choices = setNames(1:length(model_names), model_names),
              selected = 1)
})

output$download_explainer <- downloadHandler(
  filename = function() {
    paste0("explainer_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")
  },
  content = function(file) {
    xai <- tryCatch(xai_payload(), error = function(e) NULL)
    if (!is.null(xai) && !is.null(xai$explainer)) {
      saveRDS(xai, file)
    } else {
      saveRDS(list(error = "No model trained yet. Please train a model on Page 1 first."), file)
    }
  },
  contentType = "application/octet-stream"
)

output$arena_output <- renderUI({
  tags$div(
    style = "padding: 40px; text-align: center;",
  )
})
