fit_glm <- function(var_input_list, y, data_h2o_train, parameter) {
  model_display_name <- "Generalized linear regression"
  t1 <- Sys.time()
  fit <- h2o.glm(
    x = as.character(var_input_list),
    y = y,
    training_frame = data_h2o_train,
    family = parameter$family_glm,
    link = parameter$glm_link,
    intercept = parameter$intercept_term_glm,
    lambda = parameter$reg_param_glm,
    alpha = parameter$alpha_param_glm,
    max_iterations = parameter$max_iter_glm,
    seed = 123
  )

  t2 <- Sys.time()
  time_info <- data.frame(
    `Training time` = paste0(round(t2 - t1, 1), " seconds"),
    Model = model_display_name
  )

  list(fit = fit, name = model_display_name, time = time_info)
}
