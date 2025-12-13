# create dalex explainer for h2o models
explain_h2o <- function(model_obj, data_test, y) {
  explainer <- DALEXtra::explain_h2o(model_obj$fit,
    data = data_test,
    y = y,
    label = model_obj$name)

  explainer
}

# create dalex explainer for mlr models
explain_mlr <- function(model_obj, data_test, y) {
  explainer <- DALEXtra::explain_mlr(model_obj$fit,
    data = data_test,
    y = y,
    label = model_obj$name
  )
  explainer
}

# mapping from framework name to explain function
explain_function_mapping <- list(
  h2o = explain_h2o,
  mlr = explain_mlr
)
