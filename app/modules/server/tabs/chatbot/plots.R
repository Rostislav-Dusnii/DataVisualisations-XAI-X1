PLOT_COLORS <- list(
  normal = "#3498db",
  highlight = "#e74c3c"
)

# Animation settings for smooth transitions
ANIMATION_CONFIG <- list(
  transition = list(duration = 500, easing = "cubic-in-out"),
  frame = list(duration = 500, redraw = TRUE)
)

create_placeholder_plot <- function(message) {
  p <- ggplot() +
    annotate("text", x = 0.5, y = 0.5, label = message, size = 4, color = "gray50") +
    theme_void()
  plotly::ggplotly(p)
}

output$chat_var_importance_plot <- plotly::renderPlotly({
  vi <- chat_xai_results$var_importance
  highlight_var <- chat_xai_results$highlight_var

  if (is.null(vi)) {
    return(create_placeholder_plot("Ask a question to generate explanations"))
  }

  vi_df <- as.data.frame(vi)
  vi_df <- vi_df[!vi_df$variable %in% c("_baseline_", "_full_model_"), ]

  if (nrow(vi_df) == 0) {
    return(create_placeholder_plot("No variable importance data available"))
  }

  vi_agg <- aggregate(dropout_loss ~ variable, data = vi_df, FUN = mean)
  vi_agg <- vi_agg[order(vi_agg$dropout_loss, decreasing = FALSE), ]

  if (!is.null(highlight_var) && length(highlight_var) > 0 && nchar(highlight_var) > 0) {
    vi_agg$highlight <- ifelse(vi_agg$variable == highlight_var, "highlight", "normal")
  } else {
    vi_agg$highlight <- "normal"
  }

  # Build plot directly with plotly for better animation control
  colors <- ifelse(vi_agg$highlight == "highlight", PLOT_COLORS$highlight, PLOT_COLORS$normal)

  plotly::plot_ly(
    data = vi_agg,
    x = ~dropout_loss,
    y = ~reorder(variable, dropout_loss),
    type = "bar",
    orientation = "h",
    marker = list(
      color = colors,
      opacity = 0.8,
      line = list(color = colors, width = 1)
    ),
    hovertemplate = "<b>%{y}</b><br>Importance: %{x:.4f}<extra></extra>"
  ) %>%
    plotly::layout(
      title = list(text = "Variable Importance", font = list(size = 14, weight = "bold")),
      xaxis = list(title = "Dropout Loss (importance)"),
      yaxis = list(title = ""),
      margin = list(l = 120),
      transition = ANIMATION_CONFIG$transition
    ) %>%
    plotly::config(displayModeBar = FALSE)
})

output$chat_pdp_plot <- plotly::renderPlotly({
  pdp <- chat_xai_results$partial_dependence
  selected_var <- input$chat_pdp_variable

  if (is.null(pdp) || is.null(selected_var)) {
    return(create_placeholder_plot("Ask a question to generate explanations"))
  }

  pdp_df <- as.data.frame(pdp$agr_profiles)

  if (!"_vname_" %in% names(pdp_df)) {
    return(create_placeholder_plot("PDP data format error"))
  }

  pdp_var <- pdp_df[pdp_df$`_vname_` == selected_var, ]

  if (nrow(pdp_var) == 0) {
    return(create_placeholder_plot(paste("No data for:", selected_var)))
  }

  plot_df <- data.frame(x = pdp_var$`_x_`, y = pdp_var$`_yhat_`)
  plot_df <- plot_df[order(plot_df$x), ]

  # Build plot directly with plotly for better animation control
  plotly::plot_ly(data = plot_df, x = ~x, y = ~y) %>%
    plotly::add_lines(
      line = list(color = PLOT_COLORS$highlight, width = 3, shape = "spline"),
      hoverinfo = "none"
    ) %>%
    plotly::add_markers(
      marker = list(
        color = PLOT_COLORS$highlight,
        size = 8,
        line = list(color = "white", width = 2)
      ),
      hovertemplate = paste0("<b>", selected_var, "</b>: %{x:.2f}<br>Predicted: %{y:.3f}<extra></extra>")
    ) %>%
    plotly::layout(
      title = list(text = paste("Partial Dependence:", selected_var), font = list(size = 14, weight = "bold")),
      xaxis = list(title = selected_var),
      yaxis = list(title = "Average Predicted Value"),
      transition = ANIMATION_CONFIG$transition
    ) %>%
    plotly::config(displayModeBar = FALSE)
})
