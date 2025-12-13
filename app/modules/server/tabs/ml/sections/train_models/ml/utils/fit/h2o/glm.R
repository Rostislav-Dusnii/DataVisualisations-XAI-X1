# trains H2O generalized linear model
fit_glm_h2o <- function(y, data_train, parameter) {
  parameter$framework <- "h2o"
  model_display_name <- "Generalized linear regression"
  t1 <- Sys.time()
  fit <- h2o.glm(
    y = y,
    training_frame = as.h2o(data_train),
    family = parameter$family_glm,
    link = parameter$glm_link,
    intercept = parameter$intercept_term_glm,
    max_iterations = parameter$max_iter_glm,
    seed = 123
  )

  t2 <- Sys.time()
  time_info <- data.frame(
    `Training time` = paste0(round(t2 - t1, 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit, name = model_display_name, time = time_info, params = parameter)
}
