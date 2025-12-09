source(path(PATH_UI_IMPORT_DATA,"heading.R"))
source(path(PATH_UI_IMPORT_DATA,"main.R"))
source(path(PATH_UI_IMPORT_DATA,"sidebar.R"))

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
