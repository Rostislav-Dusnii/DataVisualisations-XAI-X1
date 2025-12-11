
PLOT_COLORS <- list(
  normal = "#3498db",
  highlight = "#e74c3c"
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
  vi_agg <- vi_agg[order(vi_agg$dropout_loss, decreasing = TRUE), ]

  if (!is.null(highlight_var) && length(highlight_var) > 0 && nchar(highlight_var) > 0) {
    vi_agg$highlight <- ifelse(vi_agg$variable == highlight_var, "highlight", "normal")
  } else {
    vi_agg$highlight <- "normal"
  }

  p <- ggplot(vi_agg, aes(x = reorder(variable, dropout_loss), y = dropout_loss, fill = highlight)) +
    geom_bar(stat = "identity", alpha = 0.8) +
    scale_fill_manual(values = c(normal = PLOT_COLORS$normal, highlight = PLOT_COLORS$highlight), guide = "none") +
    coord_flip() +
    labs(x = "Variable", y = "Dropout Loss (importance)", title = "Variable Importance") +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"))

  plotly::ggplotly(p) %>% plotly::layout(margin = list(l = 100))
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

  p <- ggplot(plot_df, aes(x = x, y = y)) +
    geom_line(color = PLOT_COLORS$highlight, linewidth = 1.2) +
    geom_point(color = PLOT_COLORS$highlight, size = 2) +
    labs(x = selected_var, y = "Average Predicted Value", title = paste("Partial Dependence:", selected_var)) +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"))

  plotly::ggplotly(p)
})
