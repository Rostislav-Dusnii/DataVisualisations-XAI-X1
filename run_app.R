#!/usr/bin/env Rscript

# Run the Shiny application
# Usage: ./run_app.R [port]
# Example: ./run_app.R 8888

args <- commandArgs(trailingOnly = TRUE)

# Default port
port <- 3838

# Check if port is provided
if (length(args) > 0) {
  port <- as.integer(args[1])
}

# Load required libraries
cat("Loading required libraries...\n")
required_packages <- c("shiny", "ggplot2", "plotly")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Package '%s' not found. Installing...\n", pkg))
    install.packages(pkg, repos = "https://cran.rstudio.com/")
    library(pkg, character.only = TRUE)
  }
}

cat("\n===========================================\n")
cat("Starting Data Visualizations XAI Application\n")
cat("===========================================\n")
cat(sprintf("Port: %d\n", port))
cat("Access the app at: http://127.0.0.1:", port, "\n", sep = "")
cat("Press Ctrl+C to stop the application\n")
cat("===========================================\n\n")

# Run the app
shiny::runApp(appDir = ".", port = port, launch.browser = TRUE)
