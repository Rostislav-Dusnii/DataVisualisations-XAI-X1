# --- Plot & Explain Module ---

#' Plot & Explain UI
#' @param id Module namespace ID
mod_plot_chat_ui <- function(id) {
  ns <- NS(id)

  layout_sidebar(
    sidebar = sidebar(
      selectInput(ns("x"), "X", choices = names(airquality), selected = "Temp"),
      selectInput(ns("y"), "Y", choices = names(airquality), selected = "Ozone"),
      checkboxInput(ns("smooth"), "Add smooth (trend)", TRUE),
      actionButton(ns("make_plot"), "Make plot"),
      actionButton(ns("explain_plot"), "Explain this plot", class = "btn-primary")
    ),
    card(card_header("Visualization"), plotOutput(ns("viz"), height = 420)),
    card(card_header("GPT Explanation (one-click)"), uiOutput(ns("llm_expl_ui"))),
    card(
      card_header("Plot Chat — ask questions about THIS plot"),
      p("Ask things like:",
        em("Is the relationship strong? What does a 10 unit change imply? Any outliers?")),
      shinychat::chat_ui(ns("plot_chat"), fill = TRUE)
    )
  )
}

#' Plot & Explain Server
#' @param id Module namespace ID
mod_plot_chat_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # ---- Data & Plot ----
    df <- reactive({ airquality |> tidyr::drop_na() })
    current_plot <- reactiveVal(NULL)

    observeEvent(input$make_plot, {
      req(df(), input$x, input$y)
      p <- ggplot2::ggplot(df(), ggplot2::aes_string(x = input$x, y = input$y)) +
        ggplot2::geom_point(alpha = 0.8) +
        ggplot2::theme_minimal(base_size = 13)
      if (isTRUE(input$smooth)) {
        p <- p + ggplot2::geom_smooth(method = "loess", se = FALSE)
      }
      current_plot(p)
      output$viz <- renderPlot(p)
    }, ignoreInit = TRUE)

    # ---- One-click explanation (uses raw OpenAI call for stability) ----
    observeEvent(input$explain_plot, {
      req(current_plot(), df())
      ctx <- summarize_for_llm(df(), input$x, input$y)

      user_prompt <- paste0(
        "Explain the scatter plot of ", ctx$y, " vs ", ctx$x, " to a non-technical audience.\n",
        "n=", ctx$n, ", correlation=", ctx$correlation, ", slope=", ctx$slope, "\n",
        "Ranges: ", ctx$x, " [", ctx$x_min, ",", ctx$x_max, "], ",
        ctx$y, " [", ctx$y_min, ",", ctx$y_max, "]\n",
        "Give 2 bullet points and a 1-sentence takeaway."
      )

      text <- gpt_complete(
        system_prompt = "You write grounded explanations of charts for business users. Use only the numeric context provided by the user; do not invent numbers.",
        user_prompt   = user_prompt,
        model = "gpt-4o-mini",
        temperature = 0.3
      )

      output$llm_expl_ui <- renderUI(HTML(markdownify(text)))
    })

    # ---- Plot Chat (manual handler with chat_ui + raw OpenAI call) ----
    observeEvent(input$plot_chat_user_input, {
      req(df(), input$x, input$y)
      question <- input$plot_chat_user_input

      ctx <- summarize_for_llm(df(), input$x, input$y)
      preamble <- paste0(
        "The current plot shows ", ctx$y, " vs ", ctx$x, ". ",
        "n=", ctx$n, ", correlation=", ctx$correlation, ", slope=", ctx$slope, ". ",
        "X range [", ctx$x_min, ",", ctx$x_max, "], ",
        "Y range [", ctx$y_min, ",", ctx$y_max, "]. ",
        "Use only this numeric context for any numeric claims.\n\n"
      )

      text <- gpt_complete(
        system_prompt = "You are a data visualization explainer chatbot. Be concise, accurate, and friendly. Use only the provided numeric context for claims.",
        user_prompt   = paste0(preamble, question),
        model = "gpt-4o-mini",
        temperature = 0.3
      )

      shinychat::chat_append("plot_chat", markdownify(text), session = session)
    })
  })
}
