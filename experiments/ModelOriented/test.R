library(shiny)
library(r2d3)
library(mlr)
library(DALEXtra)
library(DALEX)
library(modelStudio)
library(h2o)

h2o.init()
h2o::h2o.no_progress()
ui <- fluidPage(
  uiOutput("dashboard")
)

server <- function(input, output) {
  data <- DALEX::apartments

  # split the data
  index <- sample(seq_len(nrow(data)), 0.7 * nrow(data))
  train <- data[index, ]
  test <- data[-index, ]

  # fit a model
  task <- makeRegrTask(id = "apartments", data = train, target = "m2.price")
  learner <- makeLearner("regr.ranger", predict.type = "response")
  model <- train(learner, task)

  # create an explainer for the model
  explainer <- explain_mlr(model,
    data = test,
    y = test$m2.price,
    label = "mlr"
  )

  fit <- h2o.glm(
      x = as.character(setdiff(colnames(data), "m2.price")),
      y = "m2.price",
      training_frame = as.h2o(train),
    )
  explainer2 <- explain_h2o(fit,
    data = test,
    y = test$m2.price,
    label = "h2o"
  )

  # pick observations
  new_observation <- test[1:2, ]
  rownames(new_observation) <- c("id1", "id2")

  widget_id <- "model_studio_widget"
  ms <- modelStudio(explainer2, new_observation, widget_id = widget_id)
  ms$elementId <- NULL # :# remove elementId to stop the warning

  # :# basic render d3 output
  output[[widget_id]] <- renderD3({
    ms
  })

  # :# use render ui to set proper width and height
  output$dashboard <- renderUI({
    d3Output(widget_id, width = ms$width, height = ms$height)
  })
}

shinyApp(ui = ui, server = server)
