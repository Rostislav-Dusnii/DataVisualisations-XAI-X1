source(path(PATH_SAVE_MODELS_UTILS,"save_function_mapping.R"), local = shared_env)
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
# Track which buttons we already registered
registered_buttons <- reactiveVal(character(0))

observe({
  models <- model_training_results()$trained_models
  req(!is.null(models))
  
  current_buttons <- names(models)
  prev_buttons <- registered_buttons()
  
  # Only create observers for new buttons
  new_buttons <- setdiff(current_buttons, prev_buttons)
  if (length(new_buttons) == 0) return()
  
  for (m in new_buttons) {
    local({
      model_name <- m
      model_obj <- models[[model_name]]
      framework <- model_obj$params$framework
      display_name <- model_obj$name
      button_input_id <- paste0("save_", model_name)
      
      observeEvent(input[[button_input_id]], {
        folder_res <- isolate(global$datapath)
        
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
        
        sendSweetAlert(
          session,
          title = "Success",
          text = paste0("Model '", display_name, "' saved at: ", saved_file),
          type = "success"
        )
      })
    })
  }
  
  # Update registered buttons
  registered_buttons(c(prev_buttons, new_buttons))
})
