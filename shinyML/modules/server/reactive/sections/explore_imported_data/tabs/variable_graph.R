# Define boxplot corresponding to  selected variable in variables_class_input
output$variable_graph <- renderPlotly({
  par("mar")
  par(mar = c(1, 1, 1, 1))

  column_name <- current_dataset$available_variables[input$variables_class_input_rows_selected]
  points_serie <- eval(parse(text = paste0("data[,", column_name, "]")))

  if (input$input_var_graph_type == "Histogram") {
    req(is.numeric(points_serie))
    ggplotly(
      ggplot(data = current_dataset$data, aes(x = eval(parse(text = column_name)), fill = column_name)) +
        xlab(column_name) +
        geom_histogram(aes(y = ..density..), colour = "black", fill = "#FCADB3", bins = 30) +
        geom_density(alpha = 0.4, size = 1.3) +
        scale_fill_manual(values = "#56B4E9") +
        theme_bw(),
      tooltip = "density"
    ) %>% hide_legend()
  } else if (input$input_var_graph_type == "Boxplot") {
    plot_ly(x = points_serie, type = "box", name = column_name)
  } else if (input$input_var_graph_type == "Autocorrelation") {
    req(is.numeric(points_serie))
    acf_object <- acf(points_serie, lag.max = 100)
    data_acf <- cbind(acf_object$lag, acf_object$acf) %>%
      as.data.table() %>%
      setnames(c("Lag", "ACF"))
    plot_ly(x = data_acf$Lag, y = data_acf$ACF, type = "bar")
  }
})
