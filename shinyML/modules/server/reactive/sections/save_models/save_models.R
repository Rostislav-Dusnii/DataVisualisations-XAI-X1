source("modules/server/reactive/sections/save_models/utils/save_function_mapping.R", local = shared_env)
shinyDirChoose(
  input,
  'dir',
  roots = c(home = '~'),
  filetypes = c('')
)

global <- reactiveValues(datapath = getwd())

dir <- reactive(input$dir)

output$dir <- renderText({
  global$datapath
})

observeEvent(ignoreNULL = TRUE,
              eventExpr = {
                input$dir
              },
              handlerExpr = {
                if (!"path" %in% names(dir())) return()
                home <- normalizePath("~")
                global$datapath <-
                  file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
              })

observe({
  models <- model_training_results()$trained_models
  req(!is.null(models))

  for (model_name in names(models)) {
    local({
      m <- model_name
      model_obj <- models[[m]]
      framework <- model_obj$params$framework
      display_name <- model_obj$name

      button_input_id <- paste0("save_", m)

      observeEvent(input[[button_input_id]], {
        cat("DEBUG: Save button pressed for model:", display_name, "\n")

        folder_res <- global$datapath
        cat("DEBUG: dlg_dir result:", folder_res, "\n")

        # Check if user cancelled
        if (folder_res == "") {
          sendSweetAlert(
            session,
            title = "Cancelled",
            text = paste0("Please specify a folder to save model '", display_name, "'"),
            type = "warning"
          )
          return(NULL)
        }

        # Lookup save function
        save_fn <- save_function_mapping[[framework]]
        if (is.null(save_fn)) {
          sendSweetAlert(
            session,
            title = "Error",
            text = paste0("Unknown framework for model '", display_name, "'"),
            type = "error"
          )
          return(NULL)
        }

        # Save the model
        saved_file <- save_fn(model_obj, save_dir = folder_res)
        cat("DEBUG: model saved at:", saved_file, "\n")

        sendSweetAlert(
          session,
          title = "Success",
          text = paste0("Model '", display_name, "' saved at: ", saved_file),
          type = "success"
        )
      })
    })
  }
})

