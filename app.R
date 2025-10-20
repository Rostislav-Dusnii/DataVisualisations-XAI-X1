# Shiny R Application for Data Visualizations with XAI
# This application provides interactive data visualizations and explainable AI insights

library(shiny)
library(ggplot2)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("Data Visualizations with XAI - X1"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Data Selection"),
      selectInput("dataset", "Choose a dataset:",
                  choices = c("Iris", "mtcars", "diamonds")),
      
      hr(),
      
      h3("Visualization Options"),
      selectInput("plot_type", "Plot Type:",
                  choices = c("Scatter Plot", "Box Plot", "Histogram", "Density Plot")),
      
      conditionalPanel(
        condition = "input.plot_type == 'Scatter Plot'",
        selectInput("x_var", "X Variable:", choices = NULL),
        selectInput("y_var", "Y Variable:", choices = NULL),
        selectInput("color_var", "Color By:", choices = NULL)
      ),
      
      conditionalPanel(
        condition = "input.plot_type == 'Box Plot' || input.plot_type == 'Histogram' || input.plot_type == 'Density Plot'",
        selectInput("single_var", "Variable:", choices = NULL),
        selectInput("group_var", "Group By:", choices = NULL)
      ),
      
      hr(),
      
      h3("Model Settings"),
      checkboxInput("show_model", "Show Linear Model", FALSE),
      
      conditionalPanel(
        condition = "input.show_model == true && input.plot_type == 'Scatter Plot'",
        sliderInput("confidence", "Confidence Level:",
                    min = 0.8, max = 0.99, value = 0.95, step = 0.01)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Visualization",
                 plotlyOutput("main_plot", height = "600px"),
                 hr(),
                 verbatimTextOutput("data_summary")
        ),
        
        tabPanel("XAI Insights",
                 h3("Explainable AI Analysis"),
                 verbatimTextOutput("xai_analysis"),
                 hr(),
                 h4("Feature Importance"),
                 plotOutput("feature_importance"),
                 hr(),
                 h4("Statistical Summary"),
                 verbatimTextOutput("stat_summary")
        ),
        
        tabPanel("Data Table",
                 h3("Dataset Preview"),
                 tableOutput("data_table")
        ),
        
        tabPanel("About",
                 h3("About This Application"),
                 p("This Shiny application provides interactive data visualizations with Explainable AI (XAI) capabilities."),
                 h4("Features:"),
                 tags$ul(
                   tags$li("Multiple dataset options (Iris, mtcars, diamonds)"),
                   tags$li("Various plot types (Scatter, Box, Histogram, Density)"),
                   tags$li("Interactive visualizations with Plotly"),
                   tags$li("Linear model fitting with confidence intervals"),
                   tags$li("XAI insights including feature importance and correlations"),
                   tags$li("Statistical summaries and data exploration")
                 ),
                 h4("Technologies:"),
                 tags$ul(
                   tags$li("Shiny - Web application framework for R"),
                   tags$li("ggplot2 - Grammar of graphics visualization"),
                   tags$li("Plotly - Interactive plotting library")
                 )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive dataset
  selected_data <- reactive({
    data <- switch(input$dataset,
                   "Iris" = iris,
                   "mtcars" = mtcars,
                   "diamonds" = diamonds[sample(nrow(diamonds), 1000), ])
    return(data)
  })
  
  # Update variable choices based on selected dataset
  observe({
    data <- selected_data()
    numeric_vars <- names(data)[sapply(data, is.numeric)]
    all_vars <- names(data)
    
    updateSelectInput(session, "x_var", choices = numeric_vars, selected = numeric_vars[1])
    updateSelectInput(session, "y_var", choices = numeric_vars, selected = numeric_vars[2])
    updateSelectInput(session, "color_var", choices = c("None", all_vars), selected = "None")
    updateSelectInput(session, "single_var", choices = numeric_vars, selected = numeric_vars[1])
    updateSelectInput(session, "group_var", choices = c("None", all_vars), selected = "None")
  })
  
  # Main plot
  output$main_plot <- renderPlotly({
    req(selected_data())
    data <- selected_data()
    
    p <- NULL
    
    if (input$plot_type == "Scatter Plot") {
      req(input$x_var, input$y_var)
      
      if (input$color_var != "None") {
        p <- ggplot(data, aes_string(x = input$x_var, y = input$y_var, color = input$color_var)) +
          geom_point(alpha = 0.6) +
          theme_minimal() +
          labs(title = paste("Scatter Plot:", input$y_var, "vs", input$x_var))
      } else {
        p <- ggplot(data, aes_string(x = input$x_var, y = input$y_var)) +
          geom_point(alpha = 0.6, color = "steelblue") +
          theme_minimal() +
          labs(title = paste("Scatter Plot:", input$y_var, "vs", input$x_var))
      }
      
      if (input$show_model) {
        p <- p + geom_smooth(method = "lm", se = TRUE, level = input$confidence, color = "red")
      }
      
    } else if (input$plot_type == "Box Plot") {
      req(input$single_var)
      
      if (input$group_var != "None") {
        p <- ggplot(data, aes_string(x = input$group_var, y = input$single_var, fill = input$group_var)) +
          geom_boxplot() +
          theme_minimal() +
          labs(title = paste("Box Plot of", input$single_var, "by", input$group_var))
      } else {
        p <- ggplot(data, aes_string(y = input$single_var)) +
          geom_boxplot(fill = "steelblue") +
          theme_minimal() +
          labs(title = paste("Box Plot of", input$single_var))
      }
      
    } else if (input$plot_type == "Histogram") {
      req(input$single_var)
      
      if (input$group_var != "None") {
        p <- ggplot(data, aes_string(x = input$single_var, fill = input$group_var)) +
          geom_histogram(alpha = 0.6, position = "identity", bins = 30) +
          theme_minimal() +
          labs(title = paste("Histogram of", input$single_var, "by", input$group_var))
      } else {
        p <- ggplot(data, aes_string(x = input$single_var)) +
          geom_histogram(fill = "steelblue", bins = 30) +
          theme_minimal() +
          labs(title = paste("Histogram of", input$single_var))
      }
      
    } else if (input$plot_type == "Density Plot") {
      req(input$single_var)
      
      if (input$group_var != "None") {
        p <- ggplot(data, aes_string(x = input$single_var, fill = input$group_var)) +
          geom_density(alpha = 0.6) +
          theme_minimal() +
          labs(title = paste("Density Plot of", input$single_var, "by", input$group_var))
      } else {
        p <- ggplot(data, aes_string(x = input$single_var)) +
          geom_density(fill = "steelblue", alpha = 0.6) +
          theme_minimal() +
          labs(title = paste("Density Plot of", input$single_var))
      }
    }
    
    ggplotly(p)
  })
  
  # Data summary
  output$data_summary <- renderPrint({
    data <- selected_data()
    cat("Dataset:", input$dataset, "\n")
    cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n\n")
    cat("Column names:\n")
    print(names(data))
  })
  
  # XAI Analysis
  output$xai_analysis <- renderPrint({
    data <- selected_data()
    numeric_data <- data[, sapply(data, is.numeric)]
    
    cat("=== EXPLAINABLE AI INSIGHTS ===\n\n")
    cat("Dataset:", input$dataset, "\n\n")
    
    if (input$plot_type == "Scatter Plot" && input$show_model) {
      req(input$x_var, input$y_var)
      
      # Fit linear model
      formula <- as.formula(paste(input$y_var, "~", input$x_var))
      model <- lm(formula, data = data)
      
      cat("Linear Model Summary:\n")
      cat("-------------------\n")
      cat("Formula:", input$y_var, "~", input$x_var, "\n\n")
      cat("Coefficients:\n")
      print(coef(model))
      cat("\n")
      cat("R-squared:", round(summary(model)$r.squared, 4), "\n")
      cat("Adjusted R-squared:", round(summary(model)$adj.r.squared, 4), "\n")
      cat("P-value:", format.pval(summary(model)$coefficients[2, 4]), "\n\n")
      
      cat("Interpretation:\n")
      if (summary(model)$coefficients[2, 4] < 0.05) {
        cat("- There is a statistically significant relationship between", input$x_var, "and", input$y_var, "\n")
      } else {
        cat("- No statistically significant relationship found between", input$x_var, "and", input$y_var, "\n")
      }
      
      if (coef(model)[2] > 0) {
        cat("- Positive correlation: as", input$x_var, "increases,", input$y_var, "tends to increase\n")
      } else {
        cat("- Negative correlation: as", input$x_var, "increases,", input$y_var, "tends to decrease\n")
      }
    } else {
      cat("Enable 'Show Linear Model' with a Scatter Plot to see detailed model insights.\n\n")
    }
    
    cat("\n=== CORRELATION MATRIX (Top Correlations) ===\n")
    if (ncol(numeric_data) >= 2) {
      cor_matrix <- cor(numeric_data, use = "complete.obs")
      cor_matrix[lower.tri(cor_matrix, diag = TRUE)] <- NA
      cor_values <- na.omit(data.frame(
        Var1 = rep(rownames(cor_matrix), ncol(cor_matrix)),
        Var2 = rep(colnames(cor_matrix), each = nrow(cor_matrix)),
        Correlation = as.vector(cor_matrix)
      ))
      cor_values <- cor_values[order(-abs(cor_values$Correlation)), ]
      print(head(cor_values, 5))
    } else {
      cat("Not enough numeric variables for correlation analysis.\n")
    }
  })
  
  # Feature importance plot
  output$feature_importance <- renderPlot({
    data <- selected_data()
    numeric_data <- data[, sapply(data, is.numeric)]
    
    if (ncol(numeric_data) >= 2) {
      # Calculate variance as a simple measure of feature importance
      variances <- apply(numeric_data, 2, var, na.rm = TRUE)
      importance_df <- data.frame(
        Feature = names(variances),
        Importance = variances / sum(variances)
      )
      importance_df <- importance_df[order(-importance_df$Importance), ]
      
      ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        coord_flip() +
        theme_minimal() +
        labs(title = "Feature Importance (Normalized Variance)",
             x = "Feature",
             y = "Relative Importance")
    }
  })
  
  # Statistical summary
  output$stat_summary <- renderPrint({
    data <- selected_data()
    numeric_data <- data[, sapply(data, is.numeric)]
    
    cat("=== STATISTICAL SUMMARY ===\n\n")
    print(summary(numeric_data))
  })
  
  # Data table
  output$data_table <- renderTable({
    head(selected_data(), 20)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
