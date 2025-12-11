chatbot_tab_ui <- tagList(
  tags$div(
    style = "padding: 20px;",
    h2("XAI Chatbot"),
    tags$p("Ask questions about your trained models. The chatbot will automatically generate explanations and can highlight parts of the visualizations."),

    fluidRow(
      column(7,
        uiOutput("chat_current_model_status"),

        tags$div(
          class = "card",
          style = "margin-bottom: 15px;",
          tags$div(class = "card-header", tags$h5("Variable Importance")),
          tags$div(class = "card-body", style = "padding: 10px;",
            shinycssloaders::withSpinner(
              plotly::plotlyOutput("chat_var_importance_plot", height = "300px"),
              type = 6
            )
          )
        ),

        tags$div(
          class = "card",
          tags$div(class = "card-header",
            fluidRow(
              column(6, tags$h5("Partial Dependence Plot")),
              column(6, uiOutput("chat_pdp_variable_selector"))
            )
          ),
          tags$div(class = "card-body", style = "padding: 10px;",
            shinycssloaders::withSpinner(
              plotly::plotlyOutput("chat_pdp_plot", height = "300px"),
              type = 6
            )
          )
        )
      ),

      column(5,
        tags$div(
          class = "card",
          style = "height: 720px;",
          tags$div(class = "card-header", tags$h5("Chat with your models")),
          tags$div(class = "card-body", style = "padding: 10px;",
            shinychat::chat_ui("chat", height = "650px")
          )
        )
      )
    )
  )
)
