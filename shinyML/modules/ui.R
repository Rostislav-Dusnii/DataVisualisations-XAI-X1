import_UI <- function(data) {
  source("modules/helpers.R")
  source("modules/ui/settings.R")
  source("modules/ui/main.R")
  main <- main(data)
  source("modules/ui/footer.R")

  list(footer = footer, main = main$ui, header = main$header)
}
