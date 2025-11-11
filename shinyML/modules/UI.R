import_UI <- function(data, y) {
  source("modules/helpers.R")

  source("modules/UI/main.R")
  main <- main(data, y)

  source("modules/UI/footer.R")

  list(footer = footer, main = main)
}
