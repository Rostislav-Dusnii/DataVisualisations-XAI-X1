source("modules/ui/sections/summary.R")
source("modules/ui/sections/import_data.R")
source("modules/ui/sections/explore_imported_data.R")
source("modules/ui/sections/train_models.R")
source("modules/ui/sections/explore_results.R")

main <- argonColumn(
  width = "100%",
  summary,
  import_data,
  explore_imported_data,
  train_models,
  explore_results
)