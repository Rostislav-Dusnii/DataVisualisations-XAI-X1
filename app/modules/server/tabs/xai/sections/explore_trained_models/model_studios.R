output$model_studio_tabs <- renderUI({
  expl_list <- explainers()
  dt <- train_test_data()
  req(length(expl_list) > 0, dt$data_test_encoded)

  test_data <- dt$data_test_encoded
  new_observation <- test_data[1:2, , drop = FALSE]
  rownames(new_observation) <- paste0("id", seq_len(nrow(new_observation)))

  tab_list <- lapply(seq_along(expl_list), function(i) {
    explainer <- expl_list[[i]]
    model_label <- explainer$label
    widget_id <- paste0("model_studio_widget_", i)
    id <- widget_id

    ms <- modelStudio(explainer, new_observation, widget_id = id)
    ms$elementId <- NULL

    # isolate renderD3 for each widget
    local({
      output[[id]] <- renderD3({ ms })
    })

    # Default spinner wrapping
    spinner_ui <- withSpinner(
      d3Output(widget_id, width = ms$width, height = ms$height),
      type = 4,                  # spinner type
      color = "#1E90FF",         # spinner color
      caption = "Loading model..." # optional caption
    )

    argonTab(
      tabName = model_label,
      active = i == 1,
      argonRow(
        argonColumn(
          width = 12,
          div(
            style = "display: flex; justify-content: center;",
            spinner_ui
          )
        )
      )
    )
  })

  do.call(
    argonTabSet,
    c(
      list(
        width = 12,
        id = "model_studio_tabset",
        card_wrapper = TRUE,
        horizontal = TRUE,
        size = "sm"
      ),
      tab_list
    )
  )
})
