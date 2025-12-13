# Helper to source all R files in a directory
source_dir <- function(path, pattern = "\\.R$", recursive = FALSE, local = FALSE) {
  # List all files matching the pattern
  files <- list.files(path, pattern = pattern, full.names = TRUE, recursive = recursive)

  # Source each file with the specified local environment
  invisible(lapply(files, function(f) {
    source(f, local = local)
  }))
}