# generates XAI explanations for a model using DALEX
generate_xai_for_model <- function(model_idx) {
  tryCatch({
    all_explainers <- explainers()

    if (is.null(all_explainers) || length(all_explainers) == 0) {
      message("XAI Error: explainers list is empty")
      return(FALSE)
    }

    if (model_idx < 1 || model_idx > length(all_explainers)) {
      message(paste("XAI Error: Invalid model index:", model_idx))
      return(FALSE)
    }

    explainer <- all_explainers[[model_idx]]

    if (is.null(explainer)) {
      message("XAI Error: explainer is NULL")
      return(FALSE)
    }

    # compute variable importance and partial dependence
    chat_xai_results$var_importance <- DALEX::model_parts(explainer, type = "variable_importance")
    chat_xai_results$partial_dependence <- DALEX::model_profile(explainer, type = "partial")
    chat_xai_results$selected_model_idx <- model_idx
    chat_xai_results$highlight_var <- NULL

    TRUE
  }, error = function(e) {
    message(paste("XAI Error:", e$message))
    chat_xai_results$last_error <- e$message
    FALSE
  })
}

# creates a predict function based on model framework h2o, mlr, etc
create_predict_function <- function(model_obj) {
  framework <- model_obj$params$framework
  model_class <- class(model_obj$fit)[1]
  is_h2o <- grepl("^H2O", model_class)
  is_mlr <- inherits(model_obj$fit, "WrappedModel")

  if (is_h2o || (!is.null(framework) && framework == "h2o")) {
    function(m, newdata) {
      preds <- h2o.predict(m, as.h2o(newdata))
      as.vector(preds$predict)
    }
  } else if (is_mlr || (!is.null(framework) && framework == "mlr")) {
    function(m, newdata) {
      predict(m, newdata = newdata)$data$response
    }
  } else {
    NULL
  }
}
