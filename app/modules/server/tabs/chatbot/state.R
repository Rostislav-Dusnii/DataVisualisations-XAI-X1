# reactive state for chatbot XAI data
chat_xai_results <- reactiveValues(
  var_importance = NULL, # permutation importance results
  partial_dependence = NULL, # PDP results
  highlight_var = NULL, # currently highlighted variable in plot
  selected_model_idx = NULL, # index of selected model
  awaiting_model_selection = FALSE, # waiting for user to pick a model
  pending_question = NULL, # question to answer after model selection
  model_count_at_generation = NULL, # track when new models are trained
  last_error = NULL # last error message
)
