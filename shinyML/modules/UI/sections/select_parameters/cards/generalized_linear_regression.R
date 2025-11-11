generalized_linear_regression <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "success",
  title = "Generalized linear regression",
  div(
    align = "center",
    argonRow(
      argonColumn(
        width = 6,
        radioButtons(label = "Family", inputId = "glm_family", choices = c("gaussian", "poisson", "gamma", "tweedie"), selected = "gaussian")
      ),
      argonColumn(
        width = 6,
        radioButtons(label = "Link", inputId = "glm_link", choices = c("identity", "log"), selected = "identity"),
        switchInput(label = "Intercept term", inputId = "intercept_term_glm", value = TRUE, width = "auto")
      )
    ),
    sliderInput(label = "Lambda", inputId = "reg_param_glm", min = 0, max = 10, value = 0),
    sliderInput(label = "Alpha (0:Ridge <-> 1:Lasso)", inputId = "alpha_param_glm", min = 0, max = 1, value = 0.5),
    sliderInput(label = "Maximum iteraions", inputId = "max_iter_glm", min = 50, max = 300, value = 100),
    actionButton("run_glm", "Run glm", style = "color:white; background-color:green; padding:4px; font-size:120%", icon = icon("cogs", lib = "font-awesome"))
  )
)
