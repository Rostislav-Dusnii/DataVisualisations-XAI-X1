source("modules/ui/sections/explore_results/tabset.R")

main <- argonRow(
  argonCard(
    width = 12,
    title = "Predictions on test period",
    src = NULL,
    hover_lift = TRUE,
    shadow = TRUE,
    icon = icon("cogs"),
    status = "danger",
    tabset,
    br(),
    br(),
  )
)
