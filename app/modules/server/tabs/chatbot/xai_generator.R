
generate_xai_for_model <- function(model_idx) {
  tryCatch({
    all_models <- model_training_results()$trained_models

    if (is.null(all_models) || model_idx > length(all_models)) {
      message("XAI Error: No models or invalid index")
      return(FALSE)
    }

    model_obj <- all_models[[model_idx]]
    y_col <- target$value
    data_test <- train_test_data()[["data_test"]]

    if (is.null(data_test)) {
      message("XAI Error: data_test is NULL")
      return(FALSE)
    }

    if (!y_col %in% names(data_test)) {
      message(paste("XAI Error: y_col", y_col, "not in data_test"))
      return(FALSE)
    }

    data_test_df <- as.data.frame(data_test)
    x_test <- data_test_df[, setdiff(names(data_test_df), y_col), drop = FALSE]
    y_test <- data_test_df[[y_col]]

    predict_fun <- create_predict_function(model_obj)

    explainer <- DALEX::explain(
      model = model_obj$fit,
      data = x_test,
      y = y_test,
      label = model_obj$name,
      predict_function = predict_fun,
      verbose = FALSE
    )

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
