source(path(PATH_TRAIN_UTILS,"data_split_strategies.R"), local = shared_env)

get_data_split_strategy <- function() {
  # In case different frameworks or options require switching between split preparations
  return(split_default_data)
}
