import_UI <- function(data, y) {
  source("modules/helpers.R")
  source("modules/ui/settings.R")
  source("modules/ui/main.R")
  main <- main(data, y)
  source("modules/ui/footer.R")

  list(footer = footer, main = main)
}
