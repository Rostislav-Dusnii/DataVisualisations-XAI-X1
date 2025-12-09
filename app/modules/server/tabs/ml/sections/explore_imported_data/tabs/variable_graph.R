output$variable_graph <- renderPlotly({
  req(input$variables_class_input_rows_selected)
  
  column_name <- current_dataset$available_variables[input$variables_class_input_rows_selected]
  points_serie <- current_dataset$data[[column_name]]
  
  if (input$input_var_graph_type == "Histogram") {
    req(is.numeric(points_serie))
    col_sym <- sym(column_name)
    
    ggplotly(
      ggplot(current_dataset$data, aes(x = !!col_sym)) +
        geom_histogram(aes(y = ..density..), colour = "black", fill = "#FCADB3", bins = 30) +
        geom_density(alpha = 0.4, size = 1.3) +
        xlab(column_name) +
        theme_bw()
    ) %>% hide_legend()
    
  } else if (input$input_var_graph_type == "Boxplot") {
    plot_ly(y = points_serie, type = "box", name = column_name)
    
  } else if (input$input_var_graph_type == "Autocorrelation") {
    req(is.numeric(points_serie))
    acf_object <- acf(points_serie, lag.max = 100, plot = FALSE)
    data_acf <- data.table(Lag = acf_object$lag, ACF = acf_object$acf)
    plot_ly(x = data_acf$Lag, y = data_acf$ACF, type = "bar")
  }
})
