
chat_xai_results <- reactiveValues(
  var_importance = NULL,
  partial_dependence = NULL,
  highlight_var = NULL,
  selected_model_idx = NULL,
  awaiting_model_selection = FALSE,
  pending_question = NULL,
  model_count_at_generation = NULL,
  last_error = NULL
)
