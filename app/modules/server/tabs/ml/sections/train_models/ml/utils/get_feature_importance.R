# models that don't support feature importance
importance_disabled <- c("Generalized linear regression")

# extracts H2O variable importance (skips MLR and GLM)
get_feature_importance <- function(model_obj) {
  if (model_obj$name %in% importance_disabled ||
    model_obj$params$framework == "mlr") {
    return(NULL)
  }

  importance <- h2o.varimp(model_obj$fit) %>%
    as.data.table() %>%
    select(variable, scaled_importance) %>%
    mutate(model = model_obj$name)

  importance
}
