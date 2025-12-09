import_UI <- function(data) {
  source("modules/helpers.R")
  source("modules/ui/settings.R")
  source("modules/ui/main.R")
  source("modules/ui/footer.R")

  main_result <- main(data = data)
  list(footer = footer, main = main_result$ui)
}
