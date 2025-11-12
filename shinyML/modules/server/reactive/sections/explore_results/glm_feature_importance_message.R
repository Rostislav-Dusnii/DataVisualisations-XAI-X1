# Message indicating that feature importance is not available for glm model
output$glm_feature_importance_message <- renderUI({
  if (!is.na(v_glm$type_model) & is.na(v_random$type_model) & is.na(v_neural$type_model) & is.na(v_decision_tree$type_model) & is.na(v_grad$type_model) & is.na(v_auto_ml$type_model)) {
    sendSweetAlert(
      session = session,
      title = "Sorry ...",
      text = "Feature importance not available for generalized regression method !",
      type = "error"
    )

    argonH1("Feature importance not available for generalized regression method", display = 4)
  }
})
