observeEvent(explainers(), {

  expl_list <- explainers()
  dt <- train_test_data()

  req(length(expl_list) > 0)
  req(dt$data_test_encoded)

  test_data <- dt$data_test_encoded

  # select observations
  new_observation <- test_data[1:4, , drop = FALSE]
  rownames(new_observation) <- paste0("id", seq_len(nrow(new_observation)))

  tab_list <- lapply(seq_along(explainers()), function(i) {

    explainer <- expl_list[[i]]

    # ---- naming ----
    model_label <- explainer$label

    widget_id <- paste0("model_studio_widget_", i)
    # ---- create model studio ----
    ms <- modelStudio(
      explainer,
      new_observation,
      widget_id = widget_id
    )

    ms$elementId <- NULL

    # ---- render widget ----
    output[[widget_id]] <- renderD3({
      ms
    })

    # ---- tab UI ----
    argonTab(
      tabName = model_label,
      active = i == 1,
      argonRow(
        argonColumn(
          width = 12,
          d3Output(
            widget_id,
            width = ms$width,
            height = ms$height
          )
        )
      )
    )
  })

  # ---- render tabset ----
  output$model_studio_tabs <- renderUI({
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
})
