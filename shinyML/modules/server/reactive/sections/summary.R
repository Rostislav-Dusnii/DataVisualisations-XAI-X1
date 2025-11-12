# Define Info Box indicating which machine learning framework is used
output$framework_used <- renderUI({
  selected_framework <- "H2O"
  argonInfoCard(
    value = selected_framework, gradient = TRUE, width = 12,
    title = "Selected framework",
    icon = icon("atom"),
    icon_background = "orange",
    background_color = "lightblue"
  )
})
cluster_status <- h2o.clusterStatus()

# Define Info Box concerning memory used by framework
output$framework_memory <- renderUI({
  used_memory <- paste(round(as.numeric(cluster_status$free_mem) / 1024**3, 2), "GB", sep = "")
  title <- "H2O Cluster Total Memory"
  argonInfoCard(
    value = used_memory,
    title = title,
    gradient = TRUE, width = 12,
    icon = icon("server"),
    icon_background = "yellow",
    background_color = "lightblue"
  )
})

# Define Info Box concerning number of cpu used by cluster
output$framework_cpu <- renderUI({
  cpu_number <- cluster_status$num_cpus
  argonInfoCard(
    value = cpu_number, gradient = TRUE, width = 12,
    title = "Number of CPUs in Use",
    icon = icon("microchip"),
    icon_background = "green",
    background_color = "lightblue"
  )
})

# Define Info Box input dataset dimensions
output$dataset_infoCard <- renderUI({
  argonInfoCard(
    value = paste0(nrow(data), " rows x ", ncol(data), " columns"),
    gradient = TRUE, width = 12,
    title = "Your dataset",
    icon = icon("image"),
    icon_background = "blue",
    background_color = "lightblue"
  )
})
