create_shinyML_Server <- function(data, y) {
  source("modules/helpers.R")
  source_dir("modules/server")

  res <- process_input_data(data, y)
  data <- res$data
  y <- res$y
  x <- res$x

  # Initialize all reactive variables
  model <- reactiveValues()
  train_1 <- reactiveValues()
  test_1 <- reactiveValues()
  test_2 <- reactiveValues()
  v_neural <- reactiveValues(type_model = NA)
  v_grad <- reactiveValues(type_model = NA)
  v_glm <- reactiveValues(type_model = NA)
  v_decision_tree <- reactiveValues(type_model = NA)
  v_random <- reactiveValues(type_model = NA)
  v_auto_ml <- reactiveValues(type_model = NA)
  parameter <- reactiveValues()

  # Initialize tables for model calculation times
  time_gbm <- data.table()
  time_random_forest <- data.table()
  time_glm <- data.table()
  time_decision_tree <- data.table()
  time_neural_network <- data.table()
  time_auto_ml <- data.table()

  # Initialize tables for model variable importance (not available for generalized linear regression)
  importance_gbm <- data.table()
  importance_decision_tree <- data.table()
  importance_random_forest <- data.table()
  importance_neural_network <- data.table()

  trained_models <- reactiveValues(
    glm = NULL,
    randomForest = NULL,
    neuralNet = NULL,
    gradientBoost = NULL
  )


  # Initialize scalar values
  scaled_importance <- NULL
  variable <- NULL
  Predicted_value <- NULL
  Model <- NULL
  `.` <- NULL
  `MAPE(%)` <- NULL
  Counter <- NULL
  feature <- NULL
  importance <- NULL
  fit <- NULL
  prediction <- NULL
  `..density..` <- NULL

  server <- function(session, input, output) {
    shared_env <- list2env(list(
      input = input,
      output = output
    ))

    # Build vector resuming which Date or POSIXct columns are contained in input dataset
    dates_variable_list <- reactive({
      req(data) # ensure data is available
      get_date_columns(data)
    })

    source_dir("modules/server/reactive/sections", local = shared_env)
    source_dir("modules/server/reactive/sections/explore_imported_data", local = shared_env, recursive = TRUE)
    source_dir("modules/server/reactive/sections/select_parameters", local = shared_env)
    source_dir("modules/server/reactive/sections/explore_results", local = shared_env)


    # Define data train when time series option is not selected
    data_train_not_time_serie <- reactive({
      data %>% sample_frac(as.numeric(as.character(gsub("%", "", input$train_test_split_slider))) * 0.01)
    })

    # Define a list of object related to model results (specific for H2O framework)
    table_forecast <- reactive({
      # Make sure a value is set to checkbox_time_series checkbox
      req(!is.null(input$checkbox_time_series))

      if (input$checkbox_time_series == TRUE) {
        req(!is.null(test_1$date))
        data_train <- data.table()
        data_test <- data.table()
        data_results <- eval(parse(text = paste0("data[", input$time_series_select_column, ">'", test_1$date, "',][", input$time_series_select_column, "< '", test_2$date, "',]")))
      } else if (input$checkbox_time_series == FALSE) {
        req(!is.null(input$train_test_split_slider))

        data_train <- data_train_not_time_serie()
        data_test <- data %>% anti_join(data_train, by = colnames(data))
        data_results <- data_test
      }


      table_results <- data_results
      dl_auto_ml <- NA
      var_input_list <- c()
      for (i in 1:length(model$train_variables)) {
        var_input_list <- c(var_input_list, model$train_variables[i])
      }


      # Verify that at least one explanatory variable is selected
      if (length(var_input_list) != 0) {
        if (input$checkbox_time_series == TRUE) {
          data_h2o_train <- as.h2o(eval(parse(text = paste0("data[", input$time_series_select_column, "<='", test_1$date, "',][", input$time_series_select_column, ">='", train_1$date, "',][, !'", input$time_series_select_column, "']"))))
          data_h2o_test <- as.h2o(eval(parse(text = paste0("data[", input$time_series_select_column, ">'", test_1$date, "',][", input$time_series_select_column, "< '", test_2$date, "',][, !'", input$time_series_select_column, "']"))))
        } else if (input$checkbox_time_series == FALSE) {
          if (length(dates_variable_list()) >= 1) {
            data_train <- eval(parse(text = paste0("data_train[, !'", dates_variable_list()[1], "']")))
            data_test <- eval(parse(text = paste0("data_test[, !'", dates_variable_list()[1], "']")))
          }

          data_h2o_train <- as.h2o(data_train)
          data_h2o_test <- as.h2o(data_test)
        }


        # Calculation of glm predictions and associated calculation time
        if (!is.na(v_glm$type_model) & v_glm$type_model == "ml_generalized_linear_regression") {
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
          time_glm <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = "Generalized linear regression")
          table_glm <- h2o.predict(fit, data_h2o_test) %>%
            as.data.table() %>%
            mutate(predict = round(predict, 3)) %>%
            rename(`Generalized linear regression` = predict)
          table_results <- cbind(data_results, table_glm) %>% as.data.table()
          trained_models$glm <- fit
        }

        # Calculation of random forest predictions and associated calculation time
        if (!is.na(v_random$type_model) & v_random$type_model == "ml_random_forest") {
          t1 <- Sys.time()
          fit <- h2o.randomForest(
            x = as.character(var_input_list),
            y = y,
            training_frame = data_h2o_train,
            ntrees = parameter$num_tree_random_forest,
            sample_rate = parameter$subsampling_rate_random_forest,
            max_depth = parameter$max_depth_random_forest,
            nbins = parameter$n_bins_random_forest,
            seed = 123
          )
          t2 <- Sys.time()
          time_random_forest <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = "Random forest")
          importance_random_forest <- h2o.varimp(fit) %>%
            as.data.table() %>%
            select(`variable`, scaled_importance) %>%
            mutate(model = "Random forest")
          table_random_forest <- h2o.predict(fit, data_h2o_test) %>%
            as.data.table() %>%
            mutate(predict = round(predict, 3)) %>%
            rename(`Random forest` = predict)
          table_results <- cbind(data_results, table_random_forest) %>% as.data.table()
          trained_models$randomForest <- fit
        }

        # Calculation of neural network predictions and associated calculation time
        if (!is.na(v_neural$type_model) & v_neural$type_model == "ml_neural_network") {
          t1 <- Sys.time()
          fit <- h2o.deeplearning(
            x = as.character(var_input_list),
            y = y,
            training_frame = data_h2o_train,
            activation = parameter$activation_neural_net,
            loss = parameter$loss_neural_net,
            hidden = eval(parse(text = parameter$hidden_neural_net)),
            epochs = parameter$epochs_neural_net,
            rate = parameter$rate_neural_net,
            reproducible = T,
            seed = 123
          )
          t2 <- Sys.time()

          time_neural_network <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = "Neural network")
          importance_neural_network <- h2o.varimp(fit) %>%
            as.data.table() %>%
            select(`variable`, scaled_importance) %>%
            mutate(model = "Neural network")
          table_neural_network <- h2o.predict(fit, data_h2o_test) %>%
            as.data.table() %>%
            mutate(predict = round(predict, 3)) %>%
            rename(`Neural network` = predict)
          table_results <- cbind(data_results, table_neural_network) %>% as.data.table()
          trained_models$neuralNet <- fit
        }

        # Calculation of gradient boosted trees predictions and associated calculation time
        if (!is.na(v_grad$type_model) & v_grad$type_model == "ml_gradient_boosted_trees") {
          t1 <- Sys.time()
          fit <- h2o.gbm(
            x = as.character(var_input_list),
            y = y,
            training_frame = data_h2o_train,
            sample_rate = parameter$sample_rate_gbm,
            ntrees = parameter$n_trees_gbm,
            max_depth = parameter$max_depth_gbm,
            learn_rate = parameter$learn_rate_gbm,
            min_rows = 2,
            seed = 123
          )
          t2 <- Sys.time()
          time_gbm <- data.frame(`Training time` = paste0(round(t2 - t1, 1), " seconds"), Model = "Gradient boosted trees")
          importance_gbm <- h2o.varimp(fit) %>%
            as.data.table() %>%
            select(`variable`, scaled_importance) %>%
            mutate(model = "Gradient boosted trees")
          table_gradient_boosting <- h2o.predict(fit, data_h2o_test) %>%
            as.data.table() %>%
            mutate(predict = round(predict, 3)) %>%
            rename(`Gradient boosted trees` = predict)
          table_results <- cbind(data_results, table_gradient_boosting) %>% as.data.table()
          trained_models$gradientBoost <- fit
        }

        # Calculation of autoML predictions (max calculation time has been set to 60 seconds)
        if (!is.na(v_auto_ml$type_model) & v_auto_ml$type_model == "ml_auto") {
          req(!is.null(parameter$auto_ml_autorized_models))

          dl_auto_ml <- h2o.automl(
            x = as.character(var_input_list),
            include_algos = parameter$auto_ml_autorized_models,
            y = y,
            training_frame = data_h2o_train,
            max_runtime_secs = parameter$run_time_auto_ml,
            seed = 123
          )


          time_auto_ml <- data.frame(`Training time` = paste0(parameter$run_time_auto_ml, " seconds"), Model = "Auto ML")
          table_auto_ml <- h2o.predict(dl_auto_ml, data_h2o_test) %>%
            as.data.table() %>%
            mutate(predict = round(predict, 3)) %>%
            rename(`Auto ML` = predict)
          table_results <- cbind(data_results, table_auto_ml) %>% as.data.table()
        }

        # Assembly results of all models (some column might remain empty)
        if (!is.na(v_neural$type_model) & !is.na(v_grad$type_model) & !is.na(v_glm$type_model) & !is.na(v_random$type_model)) {
          table_results <- cbind(data_results, table_glm, table_random_forest, table_neural_network, table_gradient_boosting) %>% as.data.table()
        }
      }

      table_training_time <- rbind(time_gbm, time_random_forest, time_glm, time_neural_network, time_auto_ml)
      table_importance <- rbind(importance_gbm, importance_random_forest, importance_neural_network) %>% as.data.table()

      # Used a list to access to different tables from only on one reactive objet
      list(data_train = data_train, data_test = data_test, traning_time = table_training_time, table_importance = table_importance, results = table_results, auto_ml_model = dl_auto_ml)
    })
  }

  list(server = server)
}
