# trains MLR ranger regression model
fit_ranger_mlr <- function(y, data_train, parameter) {
  parameter$framework <- "mlr"
  model_display_name <- "Ranger Regression"
  task <- makeRegrTask(id = model_display_name, data = data_train, target = y)
  learner <- makeLearner("regr.ranger", predict.type = "response")

  t1 <- Sys.time()
  fit <- train(learner, task)
  t2 <- Sys.time()

  time_info <- data.frame(
    `Training time` = paste0(round(t2 - t1, 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit, name = model_display_name, time = time_info, params = parameter)
}
