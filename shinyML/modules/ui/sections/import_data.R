source("modules/ui/sections/import_data/heading.R")
source("modules/ui/sections/import_data/main.R")
source("modules/ui/sections/import_data/sidebar.R")

import_data <- argonDashHeader(
  gradient = TRUE,
  color = "dark",
  separator = FALSE,
  heading,
  br(),
  argonRow(
    main,
    sidebar
  )
)
