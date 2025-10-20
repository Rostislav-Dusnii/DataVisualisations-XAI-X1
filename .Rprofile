# Project-specific R profile for Data Visualizations XAI Application

# Display welcome message
.First <- function() {
  cat("\n")
  cat("====================================================\n")
  cat("  Data Visualizations with XAI - X1\n")
  cat("====================================================\n")
  cat("\n")
  cat("To run the application, use one of these methods:\n")
  cat("  1. shiny::runApp()\n")
  cat("  2. source('run_app.R')\n")
  cat("  3. Open app.R in RStudio and click 'Run App'\n")
  cat("\n")
  cat("Required packages: shiny, ggplot2, plotly\n")
  cat("====================================================\n")
  cat("\n")
}

# Set options
options(
  repos = c(CRAN = "https://cran.rstudio.com/"),
  shiny.maxRequestSize = 30*1024^2,  # 30MB max file upload
  shiny.trace = FALSE,                # Disable tracing in production
  warn = 1                            # Show warnings as they occur
)

# Auto-load common packages in interactive sessions
if (interactive()) {
  suppressMessages({
    # Check and install missing packages
    required_packages <- c("shiny", "ggplot2", "plotly")
    missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
    
    if (length(missing_packages) > 0) {
      cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
      install.packages(missing_packages)
    }
  })
}
