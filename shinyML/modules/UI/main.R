main <- function(data = data, y = y) {
  dashheader_select_parameters <- NULL
  Sys.setenv(http_proxy = "")
  Sys.setenv(http_proxy_user = "")
  Sys.setenv(https_proxy_user = "")
  h2o.init()
  h2o::h2o.no_progress()

  cluster_status <- h2o.clusterStatus()

  source("modules/UI/sections/summary.R")
  summary <- summary()

  source("modules/UI/sections/explore_imported_data.R")
  explore_imported_data <- explore_imported_data(data = data, y = y)

  source("modules/UI/sections/select_parameters.R")
  select_parameters <- select_parameters()

  source("modules/UI/sections/explore_results.R")
  explore_results <- explore_results()

  sections <- argonColumn(
    width = "100%",
    summary$ui,
    explore_imported_data$section,
    select_parameters$section,
    explore_results$section
  )

  list(ui = sections)
}
