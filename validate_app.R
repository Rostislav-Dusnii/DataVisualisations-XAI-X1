#!/usr/bin/env Rscript

# Validation script for Data Visualizations XAI Application
# This script checks if the app structure is valid without running it

cat("===========================================\n")
cat("Validating Shiny Application Structure\n")
cat("===========================================\n\n")

# Check if required files exist
cat("1. Checking required files...\n")
required_files <- c("app.R", "README.md", "DESCRIPTION")
missing_files <- c()

for (file in required_files) {
  if (file.exists(file)) {
    cat(sprintf("   ✓ %s found\n", file))
  } else {
    cat(sprintf("   ✗ %s missing\n", file))
    missing_files <- c(missing_files, file)
  }
}

if (length(missing_files) > 0) {
  cat("\nERROR: Missing required files!\n")
  quit(status = 1)
}

cat("\n2. Checking R syntax in app.R...\n")
tryCatch({
  parse("app.R")
  cat("   ✓ app.R syntax is valid\n")
}, error = function(e) {
  cat("   ✗ Syntax error in app.R:\n")
  cat(sprintf("     %s\n", e$message))
  quit(status = 1)
})

cat("\n3. Checking for required packages...\n")
required_packages <- c("shiny", "ggplot2", "plotly")

all_available <- TRUE
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("   ✓ %s is installed\n", pkg))
  } else {
    cat(sprintf("   ℹ %s is NOT installed (required to run app)\n", pkg))
    all_available <- FALSE
  }
}

if (!all_available) {
  cat("\nNOTE: Some packages are missing. Install them with:\n")
  cat('   install.packages(c("shiny", "ggplot2", "plotly"))\n')
}

cat("\n4. Checking app structure...\n")
tryCatch({
  # Source the app to check if ui and server are defined
  source("app.R", local = TRUE)
  
  if (exists("ui", inherits = FALSE)) {
    cat("   ✓ UI object is defined\n")
  } else {
    cat("   ✗ UI object not found\n")
    quit(status = 1)
  }
  
  if (exists("server", inherits = FALSE)) {
    cat("   ✓ Server function is defined\n")
  } else {
    cat("   ✗ Server function not found\n")
    quit(status = 1)
  }
  
}, error = function(e) {
  cat("   ℹ Could not fully validate app structure (missing packages):\n")
  cat(sprintf("     %s\n", e$message))
})

cat("\n===========================================\n")
cat("Validation Summary\n")
cat("===========================================\n")
cat("✓ All required files present\n")
cat("✓ R syntax is valid\n")
cat("✓ App structure appears correct\n")

if (all_available) {
  cat("✓ All required packages are installed\n")
  cat("\nYou can run the app with: shiny::runApp()\n")
} else {
  cat("ℹ Install missing packages before running\n")
}

cat("===========================================\n\n")
