glm_h2o <- argonCard(
  width = 3,
  icon = icon("sliders"),
  status = "primary",
  title = "h2o framework",
  div(
    align = "center",
    h1("Generalized linear regression"),
    argonRow(
      argonColumn(
        width = 6,
        radioButtons(
          label = "Family",
          inputId = "glm_family",
          choices = c("gaussian", "poisson", "gamma", "tweedie"),
          selected = "gaussian"
        )
      ),
      argonColumn(
        width = 6,
        radioButtons(
          label = "Link",
          inputId = "glm_link",
          choices = c("identity", "log"),
          selected = "identity"
        ),
        switchInput(
          label = "Intercept term",
          inputId = "intercept_term_glm",
          value = TRUE,
          width = "auto"
        )
      )
    ),
    sliderInput("reg_param_glm", "Lambda", min = 0, max = 10, value = 0),
    sliderInput("alpha_param_glm", "Alpha (0:Ridge <-> 1:Lasso)", min = 0, max = 1, value = 0.5),
    sliderInput("max_iter_glm", "Maximum iterations", min = 50, max = 300, value = 100),
    checkboxInput("select_glm_h2o", "Select model", value = FALSE)
  )
)
