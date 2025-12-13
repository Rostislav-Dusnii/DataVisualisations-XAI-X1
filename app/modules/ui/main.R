# Load tab UI modules
source_dir(PATH_UI_ML)
source_dir(PATH_UI_XAI)
source_dir(PATH_UI_CHATBOT)

# Main content area - conditionally renders each tab
main <- tags$div(
  id = "main_tabs",
  conditionalPanel(
    condition = "input.current_page == 'page1' || typeof input.current_page === 'undefined'",
    ml_tab_ui
  ),
  conditionalPanel(
    condition = "input.current_page == 'page2'",
    xai_tab_ui
  ),
  conditionalPanel(
    condition = "input.current_page == 'page3'",
    chatbot_tab_ui
  )
)
