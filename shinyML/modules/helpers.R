source_dir <- function(path, pattern = "\\.R$", recursive = FALSE) {
  files <- list.files(path, pattern = pattern, full.names = TRUE, recursive = recursive)
  invisible(lapply(files, source))
}
