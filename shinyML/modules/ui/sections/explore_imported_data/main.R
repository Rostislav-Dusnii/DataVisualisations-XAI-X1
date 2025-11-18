main <- function(data) {
  source("modules/ui/sections/explore_imported_data/tabset.R")
  tabset <- tabset(data)

  ui <- argonColumn(
    width = 9,
    argonCard(
      width = 12, hover_lift = TRUE, shadow = TRUE,
      tabset$ui
    )
  )
  list(ui = ui)
}
