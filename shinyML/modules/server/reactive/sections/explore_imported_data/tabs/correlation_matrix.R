# Define correlation matrix object
output$correlation_matrix <- renderPlotly({
  data_correlation <- as.matrix(select_if(data, is.numeric))
  plot_ly(x = colnames(data_correlation), y = colnames(data_correlation), z = cor(data_correlation), type = "heatmap", source = "heatplot")
})
