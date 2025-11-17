# Define a blacklist of models without feature importance
importance_disabled <- c("Generalized linear regression", "Auto ML")

get_feature_importance <- function(model_obj) {
  # Return NULL if the model is in the blacklist
  if (model_obj$name %in% importance_disabled) {
    return(NULL)
  }

  # Otherwise, extract feature importance
  importance <- h2o.varimp(model_obj$fit) %>%
    as.data.table() %>%
    select(variable, scaled_importance) %>%
    mutate(model = model_obj$name)

  return(importance)
}
