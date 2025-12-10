explain_h2o <- function(model_obj, data_test, y) {
  explainer <- DALEXtra::explain_h2o(model_obj$fit,
    data = data_test,
    y = y,
    label = model_obj$name)

  explainer
}

explain_mlr <- function(model_obj, data_test, y) {
  explainer <- DALEXtra::explain_mlr(model_obj$fit,
    data = data_test,
    y = y,
    label = model_obj$name
  )
  explainer
}

explain_function_mapping <- list(
  h2o = explain_h2o,
  mlr = explain_mlr
)
