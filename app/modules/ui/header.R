# Custom header with navigation tabs (Train Models, Arena.drwhy, Chatbot)
header <- tagList(
    # Header styling
    tags$style(HTML("
      .custom-header {
        background: linear-gradient(87deg, #f5365c 0, #f56036 100%);
        padding: 1rem 0 0 0;
        margin-bottom: 2rem;
      }
      .custom-header .container-fluid {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 30px;
      }
      .header-title {
        color: white;
        margin: 0 0 1rem 0;
        font-size: 1.8rem;
        font-weight: 600;
      }
      .nav-tabs-custom {
        border-bottom: none;
        margin: 0;
        display: flex;
        gap: 0;
      }
      .nav-tabs-custom .nav-link {
        border: none;
        color: rgba(255, 255, 255, 0.8);
        padding: 1rem 1.5rem;
        font-weight: 500;
        border-bottom: 3px solid transparent;
        transition: all 0.2s;
        background: transparent;
        border-radius: 0;
      }
      .nav-tabs-custom .nav-link:hover {
        color: white;
        border-bottom-color: rgba(255, 255, 255, 0.5);
        background: rgba(255, 255, 255, 0.1);
      }
      .nav-tabs-custom .nav-link.active {
        color: white;
        border-bottom-color: white;
        background: rgba(255, 255, 255, 0.15);
      }
      /* Hide the original tabset navigation */
      #main_tabs > .nav.nav-tabs,
      #main_tabs > ul.nav.nav-tabs {
        display: none !important;
      }
      /* Also hide any nav-tabs that are direct children of the tab content */
      .tab-content > .nav.nav-tabs {
        display: none !important;
      }
    ")),
    tags$div(
      class = "custom-header",
      tags$div(
        class = "container-fluid",
        tags$h1("ML & XAI", class = "header-title"),
        tags$ul(
          class = "nav nav-tabs nav-tabs-custom",
          id = "customNavbar",
          tags$li(
            class = "nav-item",
            tags$a(
              class = "nav-link active",
              href = "#",
              `data-toggle` = "tab",
              `data-value` = "page1",
              onclick = "Shiny.setInputValue('navbar_switch', 'page1', {priority: 'event'})",
              "Train Models"
            )
          ),
          tags$li(
            class = "nav-item",
            tags$a(
              class = "nav-link",
              href = "#",
              `data-toggle` = "tab",
              `data-value` = "page2",
              onclick = "Shiny.setInputValue('navbar_switch', 'page2', {priority: 'event'})",
              "Arena.drwhy"
            )
          ),
          tags$li(
            class = "nav-item",
            tags$a(
              class = "nav-link",
              href = "#",
              `data-toggle` = "tab",
              `data-value` = "page3",
              onclick = "Shiny.setInputValue('navbar_switch', 'page3', {priority: 'event'})",
              "Chatbot"
            )
          )
        )
      )
    ),
    # Tab switching JavaScript
    tags$script(HTML("
      $(document).on('click', '.nav-tabs-custom .nav-link', function(e) {
        e.preventDefault();
        $('.nav-tabs-custom .nav-link').removeClass('active');
        $(this).addClass('active');
      });

      Shiny.addCustomMessageHandler('switch_page', function(page) {
        Shiny.setInputValue('current_page', page);

        setTimeout(function() {
          $(window).trigger('resize');
        }, 100);
      });
    "))
  )
