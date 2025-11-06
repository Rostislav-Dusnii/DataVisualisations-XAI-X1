# =============================================================================
# Page 2 - Model Visualizations
# =============================================================================
# Converted from ModelOriented/test.R to a Shiny module

#' Page 2 UI - Model Visualizations
#' @param id Module namespace ID
mod_page2_ui <- function(id) {
  ns <- NS(id)

  tagList(
    uiOutput(ns("dashboard"))
  )
}

#' Page 2 Server - Model Visualizations
#' @param id Module namespace ID
#' @return Reactive with model context for Page 3 chatbot
mod_page2_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    data <- DALEX::apartments

    # split the data
    index <- sample(seq_len(nrow(data)), 0.7 * nrow(data))
    train <- data[index, ]
    test <- data[-index, ]

    # fit a model
    task <- mlr::makeRegrTask(id = "apartments", data = train, target = "m2.price")
    learner <- mlr::makeLearner("regr.ranger", predict.type = "response")
    model <- mlr::train(learner, task)

    # create an explainer for the model
    explainer <- DALEXtra::explain_mlr(model,
      data = test,
      y = test$m2.price,
      label = "Random Forest"
    )

    # pick observations
    new_observation <- test[1:2, ]
    rownames(new_observation) <- c("id1", "id2")

    # Create modelStudio without specifying widget_id to avoid conflicts
    ms <- modelStudio::modelStudio(explainer, new_observation)

    # Render the widget directly without wrapper
    output$dashboard <- renderUI({
      ms
    })

    # Return model context for Page 3 chatbot
    model_context <- reactive({
      list(
        dataset = "Apartments (Warsaw, Poland)",
        target = "m2.price (price per square meter)",
        model_type = "Random Forest Regression",
        features = paste(setdiff(names(data), "m2.price"), collapse = ", "),
        n_train = nrow(train),
        n_test = nrow(test),
        observations_explained = 2
      )
    })

    return(model_context)
  })
}
