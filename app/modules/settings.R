# App settings and initialization
dashheader_select_parameters <- NULL
# Clear proxy settings
Sys.setenv(http_proxy = "")
Sys.setenv(http_proxy_user = "")
Sys.setenv(https_proxy_user = "")
# Initialize H2O cluster
h2o.init()
h2o::h2o.no_progress()
options(dplyr.summarise.inform = F)