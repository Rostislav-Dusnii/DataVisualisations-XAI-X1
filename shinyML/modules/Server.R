create_shinyML_Server <- function(data, y) {

  ## ---------------------------------------------------------------------------- INITIALISATION  -----------------------------------
  
  # Ensure reproducibility
  set.seed(123)
  framework <- "h2o"

  # Convert input dataset a data.table object
  data <- data.table(data) 
  
  # Replace '.' by '_' in dataset colnames
  colnames(data) <- gsub("\\.","_",colnames(data))
  
  # Replace '.' by '_' in output variable
  y <- gsub("\\.","_",y)
  
  # Return an error if y is not contained in dataset colnames
  if (!(y %in% colnames(data))){
    stop("y must match one data input variable")
  }
  
  # Return an error if y class is not numeric
  if (!(eval(parse(text = paste0("class(data$",y,")"))) == "numeric")){
    stop("y column class must be numeric")
  }
  
  # Assign x as explanatory variables (x does not include output variable) 
  x <- setdiff(colnames(data),y)
  
  # Return an error if input dataset exceed one million rows
  if (nrow(data) > 1000000) {
    stop("Input dataset must not exceed one million rows")
  }
  
  # Don't print summarize() regrouping message 
  options(dplyr.summarise.inform=F)
  
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

server = function(session,input, output) {
    
    # Build vector resuming which Date or POSIXct columns are contained in input dataset 
    dates_variable_list <- reactive({
      dates_columns_list <- c()
      for (i in colnames(data)){
        if (is.Date(eval(parse(text = paste0("data$",i)))) | is.POSIXct(eval(parse(text = paste0("data$",i))))){
          dates_columns_list <- c(dates_columns_list,i)
        }
      }
      dates_columns_list
    })
    
    # Checkbox to consider time serie analysis or not (only possible if input dataset contains at least one Date or POSIXct column)
    output$Time_series_checkbox <- renderUI({
      
      if (length(dates_variable_list()) >= 1){value = TRUE}
      else {value = FALSE}
      
      awesomeCheckbox("checkbox_time_series", "Time series",status = "primary",value = value)
      
    })
    
    # Hide checkbox if input dataset does not contain one or more Date or POSIXct column
    observe({
      if (length(dates_variable_list()) == 0){
        shinyjs::hideElement("Time_series_checkbox")
      }
    })
    
    # Set test_1 and test_2 parameters (only applicable for time series analysis)
    observe({
      
      req(!is.null(input$checkbox_time_series))
      if (input$checkbox_time_series == TRUE){
        req(!is.null(input$time_serie_select_column))
        test_1$date <-  eval(parse(text = paste0("mean(as.Date(data$",input$time_serie_select_column,"))")))
        test_2$date <-  eval(parse(text = paste0("max(as.Date(data$",input$time_serie_select_column,"))")))
      }
      
    }) 
    
    # Define Info Box indicating which machine learning framework is used
    output$framework_used <- renderUI({
      selected_framework <- "H2O"
      
      argonInfoCard(
        value = selected_framework,gradient = TRUE,width = 12,
        title = "Selected framework",
        icon = icon("atom"), 
        icon_background = "orange",
        background_color = "lightblue"
      )
      
    })
    cluster_status <- h2o.clusterStatus()
    
    # Define Info Box concerning memory used by framework
    output$framework_memory <- renderUI({
      
      used_memory <- paste(round(as.numeric(cluster_status$free_mem)/1024**3,2), "GB", sep = "")
      title <- "H2O Cluster Total Memory"
    
      
      argonInfoCard(
        value = used_memory ,
        title = title,
        gradient = TRUE,width = 12,
        icon = icon("server"), 
        icon_background = "yellow",
        background_color = "lightblue"
      )
    })
    
    # Define Info Box concerning number of cpu used by cluster
    output$framework_cpu <- renderUI({
      
      cpu_number <- cluster_status$num_cpus
      
      argonInfoCard(
        value = cpu_number,gradient = TRUE,width = 12,
        title = "Number of CPUs in Use",
        icon = icon("microchip"), 
        icon_background = "green",
        background_color = "lightblue"
      )
    })
    
    # Define Info Box input dataset dimensions 
    output$dataset_infoCard <- renderUI({
      argonInfoCard(
        value = paste0(nrow(data)," rows x ",ncol(data)," columns"),
        gradient = TRUE,width = 12,
        title = "Your dataset",
        icon = icon("image"), 
        icon_background = "blue",
        background_color = "lightblue"
      )
    })
    
    # Define indicating number of rows contained in testing dataset
    output$message_nrow_train_dataset <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      req(!is.null(table_forecast()[["data_train"]]))
      
      if (input$checkbox_time_series == TRUE){
        number_rows_datatest <- nrow(eval(parse(text = paste0("data[",input$time_serie_select_column," >= input$train_selector[1],][",input$time_serie_select_column," <= input$train_selector[2],]"))))
      }
      
      else if (input$checkbox_time_series == FALSE){
        number_rows_datatest <- nrow(table_forecast()[["data_train"]])
      }
      
      argonBadge(text = HTML(paste0("<big><big>Training dataset contains <b>",number_rows_datatest,"</b> rows</big></big>")),status = "success")
      
    })
    
    # Define indicating that autocorrelation plot is only available for time series
    output$message_autocorrelation <- renderUI({
      
      points_serie <-eval(parse(text = paste0("data[,",colnames(data)[input$variables_class_input_rows_selected],"]"))) 
      if (input$input_var_graph_type %in% c("Histogram","Autocorrelation") & !is.numeric(points_serie)){
        argonH1("Only available for numerical variables",display = 4)
      }
    })
    
    # Make glm parameters correspond to cursors and radiobuttons choices when user click on "Run generalized linear regression" button 
    observeEvent(input$run_glm,{
      
      train_1$date <- input$train_selector[1]
      test_1$date <- input$test_selector[1]
      test_2$date <- input$test_selector[2]
      model$train_variables <- input$input_variables
      v_grad$type_model <- NA
      v_neural$type_model <- NA
      v_random$type_model <- NA
      v_decision_tree$type_model <- NA
      v_auto_ml$type_model <- NA
      v_glm$type_model <- "ml_generalized_linear_regression"
      
      parameter$family_glm <- input$glm_family
      parameter$glm_link <- input$glm_link
      parameter$intercept_term_glm <- input$intercept_term_glm
      parameter$reg_param_glm <- input$reg_param_glm
      parameter$alpha_param_glm <- input$alpha_param_glm
      parameter$max_iter_glm <- input$max_iter_glm
    })
    
    # Make random forest parameters correspond to cursors when user click on "Run random forest model" button (and disable other models)
    observeEvent(input$run_random_forest,{
      
      
      train_1$date <- input$train_selector[1]
      test_1$date <- input$test_selector[1]
      test_2$date <- input$test_selector[2]
      model$train_variables <- input$input_variables
      v_grad$type_model <- NA
      v_neural$type_model <- NA
      v_glm$type_model <- NA
      v_auto_ml$type_model <- NA
      v_decision_tree$type_model <- NA
      
      
      v_random$type_model <- "ml_random_forest"
      
      
      parameter$num_tree_random_forest <- input$num_tree_random_forest
      parameter$subsampling_rate_random_forest <- input$subsampling_rate_random_forest
      parameter$max_depth_random_forest <-  input$max_depth_random_forest
      parameter$n_bins_random_forest <- input$n_bins_random_forest
      
    })
    
    # Make gradient boosting parameters correspond to cursors when user click on "Run gradient boosting model" button (and disable other models)
    observeEvent(input$run_gradient_boosting,{
      
      train_1$date <- input$train_selector[1]
      test_1$date <- input$test_selector[1]
      test_2$date <- input$test_selector[2]
      model$train_variables <- input$input_variables
      v_grad$type_model <- "ml_gradient_boosted_trees"
      v_neural$type_model <- NA
      v_glm$type_model <- NA
      v_random$type_model <- NA
      v_auto_ml$type_model <- NA
      v_decision_tree$type_model <- NA
      
      
      parameter$sample_rate_gbm <- input$sample_rate_gbm
      parameter$n_trees_gbm <- input$n_trees_gbm
      parameter$max_depth_gbm <- input$max_depth_gbm
      parameter$learn_rate_gbm <- input$learn_rate_gbm
      parameter$step_size_gbm <- input$step_size_gbm
      parameter$subsampling_rate_gbm <- input$subsampling_rate_gbm
      
    })
    
    # Define train slider (only applicable for time series analysis) 
    output$slider_time_series_train <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      req(!is.null(input$time_serie_select_column))
      
      if (input$checkbox_time_series == TRUE){
        sliderInput("train_selector", "Choose train period:",
                    min = eval(parse(text = paste0("min(data$",input$time_serie_select_column,")"))),
                    max = eval(parse(text = paste0("max(data$",input$time_serie_select_column,")"))),
                    value =  eval(parse(text = paste0("c(min(data$",input$time_serie_select_column,"),mean(data$",input$time_serie_select_column,"))"))))
      }
    })
    
    # Define test slider (only applicable for time series analysis) 
    output$slider_time_series_test <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      req(!is.null(input$time_serie_select_column))
      
      if (input$checkbox_time_series == TRUE){
        sliderInput("test_selector", "Choose test period:",
                    min = eval(parse(text = paste0("min(data$",input$time_serie_select_column,")"))),
                    max = eval(parse(text = paste0("max(data$",input$time_serie_select_column,")"))),
                    value = eval(parse(text = paste0("c(mean(data$",input$time_serie_select_column,"),max(data$",input$time_serie_select_column,"))"))))
      }
      
    })
    
    # Define slider percentage to separate training dataset from testing dataset 
    output$slider_percentage <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      
      if (input$checkbox_time_series == FALSE){
        
        selectInput(label = "Train/ Test splitting",inputId = "percentage_selector",choices = paste0(c(50:99),"%"),selected = 70,multiple = FALSE)
        
      }
    })
    
    # Define selectInput to choose which Date or POSIXct column to use among input dataset colnames (only applicable for time series analysis)
    output$time_series_column <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      if (input$checkbox_time_series == TRUE){
        selectInput(inputId = "time_serie_select_column",label = "Date column",choices = dates_variable_list(),multiple = FALSE)
      }
    })
    
    # Define explanatory variables list
    output$Variables_input_selection<- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      variable_input_list <- x[!(x %in% dates_variable_list())]
      selectInput( inputId  = "input_variables",label = "Input variables: ",choices = x,multiple = TRUE,selected = variable_input_list)
    })
    
    # Define X-axis for input data chart 
    output$X_axis_explore_dataset <- renderUI({
      
      req(!is.null(input$checkbox_time_series))
      if (input$checkbox_time_series == TRUE){
        req(!is.null(input$time_serie_select_column))
        selected_column <- input$time_serie_select_column        
      }
      
      else {selected_column <- colnames(data)[1]}
      
      selectInput(inputId = "x_variable_input_curve",label = "X-axis variable",choices = colnames(data),selected = selected_column)
    })
    
    # Define input data summary with class of each variable 
    output$variables_class_input <- renderDT({
      table_classes <- data.table()
      
      for (i in 1:ncol(data)){
        
        table_classes <- rbind(table_classes,
                               data.frame(Variable = colnames(data)[i],
                                          Class = class(eval(parse(text = paste0("data$",colnames(data)[i]))))
                               )
        )
      }
      
      datatable(table_classes,options = list(pageLength =10,searching = FALSE,lengthChange = FALSE),selection = list(mode = "single",selected = c(1))
      )
    })
    
    # Define boxplot corresponding to  selected variable in variables_class_input 
    output$variable_boxplot <- renderPlotly({
      
      par("mar")
      par(mar=c(1,1,1,1))
      
      column_name <- colnames(data)[input$variables_class_input_rows_selected]
      points_serie <-eval(parse(text = paste0("data[,",column_name,"]"))) 
      
      if (input$input_var_graph_type == "Histogram"){
        req(is.numeric(points_serie))
        ggplotly(
          ggplot(data = data,aes(x = eval(parse(text = column_name)),fill = column_name))+
            xlab(column_name)+
            geom_histogram(aes(y=..density..), colour="black", fill="#FCADB3",bins = 30)+
            geom_density(alpha = 0.4,size = 1.3) +
            scale_fill_manual(values="#56B4E9")+
            theme_bw(),tooltip = "density"
        ) %>% hide_legend()
      }
      else if (input$input_var_graph_type == "Boxplot"){
        plot_ly(x = points_serie,type = "box",name = column_name)
      }
      else if (input$input_var_graph_type == "Autocorrelation"){
        req(is.numeric(points_serie))
        acf_object <- acf(points_serie,lag.max = 100)
        data_acf <- cbind(acf_object$lag,acf_object$acf) %>% as.data.table() %>% setnames(c("Lag","ACF"))
        plot_ly(x = data_acf$Lag, y = data_acf$ACF, type = "bar")
        
      }
      
    })
    
    # Define plotly chart to explore dependencies between variables 
    output$explore_dataset_chart <- renderPlotly({
      
      req(!is.null(input$checkbox_time_series))
      req(!is.null(input$x_variable_input_curve))
      req(!is.null(input$y_variable_input_curve))
      
      if (input$checkbox_time_series == TRUE){
        data_train_chart <- eval(parse(text = paste0("data[",input$time_serie_select_column," >= input$train_selector[1],][",input$time_serie_select_column," <= input$train_selector[2],]")))
        data_test_chart <- eval(parse(text = paste0("data[",input$time_serie_select_column," > input$test_selector[1],][",input$time_serie_select_column," <= input$test_selector[2],]")))
        
      }
      
      else if (input$checkbox_time_series == FALSE){
        
        req(!is.null(table_forecast()[["data_train"]]))
        data_train_chart <- table_forecast()[["data_train"]]
        data_test_chart <- table_forecast()[["data_test"]]
        
      }
      
      plot_ly(data = data_train_chart, x = eval(parse(text = paste0("data_train_chart$",input$x_variable_input_curve))), 
              y = eval(parse(text = paste0("data_train_chart$",input$y_variable_input_curve))),
              type = "scatter",mode = "markers",
              name = "Training dataset") %>% 
        add_trace(x = eval(parse(text = paste0("data_test_chart$",input$x_variable_input_curve))), 
                  y = eval(parse(text = paste0("data_test_chart$",input$y_variable_input_curve))),
                  type = "scatter",mode = "markers",
                  name = "Testing dataset") %>% 
        layout(xaxis = list(title = input$x_variable_input_curve),  yaxis = list(title = input$y_variable_input_curve),legend = list(orientation = "h",xanchor = "center",x = 0.5,y= 1.2))
      
    })
    
    # Define correlation matrix object
    output$correlation_matrix <- renderPlotly({
      
      data_correlation <- as.matrix(select_if(data, is.numeric))
      plot_ly(x = colnames(data_correlation) , y = colnames(data_correlation), z =cor(data_correlation)  ,type = "heatmap", source = "heatplot")
    })
    
    # Define output chart comparing predicted vs real values on test period for selected model(s)
    output$output_curve <- renderDygraph({
      
      
      req(!is.null(input$checkbox_time_series))
      
      if (input$checkbox_time_series == TRUE){
        req(!is.null(input$time_serie_select_column))
        data_output_curve <- table_forecast()[['results']] %>% select(-input$input_variables)
        
      }
      
      else if (input$checkbox_time_series == FALSE){
        data_output_curve <- table_forecast()[['results']] %>% 
          select(-c(setdiff(colnames(data),y))) %>% 
          mutate(Counter = row_number()) %>% 
          select(Counter,everything())
        
      }
      
      output_dygraph <- dygraph(data = data_output_curve ,main = "Prediction results on test period",width = "100%",height = "150%") %>%
        dyAxis("x",valueRange = c(0,nrow(data))) %>% 
        dyAxis("y",valueRange = c(0,1.5 * max(eval(parse(text =paste0("table_forecast()[['results']]$",y)))))) %>%
        dyOptions(animatedZooms = TRUE,fillGraph = T,drawPoints = TRUE, pointSize = 2)
      
      
      
      # chart can be displayed with bar or line mode
      if (input$bar_chart_mode == TRUE){
        output_dygraph <- output_dygraph %>% dyBarChart()
      }
      
      output_dygraph %>% dyLegend(width = 800)
      
    })
    
    # Define performance table visible on "Compare models performances" tab
    output$score_table <- renderDT({
      
      
      req(ncol(table_forecast()[['results']]) > ncol(data))
      req(!is.null(input$checkbox_time_series))
      
      if (input$checkbox_time_series == TRUE){
        
        req(!is.null(input$time_serie_select_column))
        
        performance_table <-  eval(parse(text = paste0("table_forecast()[['results']] %>% 
                                                         gather(key = Model,value = Predicted_value,-",input$time_serie_select_column,",-y) %>% 
                                                         as.data.table()")))
      }
      
      else if (input$checkbox_time_series == FALSE){
        
        performance_table <-  table_forecast()[['results']] %>%
          select(-c(setdiff(colnames(data),y))) %>% 
          gather(key = Model,value = Predicted_value,-y) %>%
          as.data.table()
      }
      
      performance_table <- performance_table %>% 
        group_by(Model) %>%
        summarise(`MAPE(%)` = round(100 * mean(abs((Predicted_value - eval(parse(text = y)))/eval(parse(text = y))),na.rm = TRUE),1),
                  RMSE = round(sqrt(mean((Predicted_value - eval(parse(text = y)))**2)),2))
      
      
      if (nrow(table_forecast()[['traning_time']]) != 0){
        performance_table <- performance_table %>% merge(.,table_forecast()[['traning_time']],by = "Model")
      }
      
      datatable(
        performance_table %>% arrange(`MAPE(%)`) %>% as.data.table()
        , extensions = 'Buttons', options = list(dom = 'Bfrtip',buttons = c('csv', 'excel', 'pdf', 'print'))
      )
    })
    
    # Define importance features table table visible on "Feature importance" tab
    output$feature_importance <- renderPlotly({
      
      if (nrow(table_forecast()[['table_importance']]) != 0){
          ggplotly(
            
            ggplot(data = table_forecast()[['table_importance']])+
              geom_bar(aes(x = reorder(`variable`,scaled_importance),y = scaled_importance,fill =  `model`),stat = "identity",width = 0.3)+
              facet_wrap( model ~ .)+
              coord_flip()+
              xlab("")+
              ylab("")+
              theme(legend.position="none")
          )
      }
      
    })
    
    # Define results table 
    output$table_of_results <- renderDT({
      
      datatable(
        table_forecast()[['results']],
        extensions = 'Buttons', options = list(dom = 'Bfrtip',buttons = c('csv', 'excel', 'pdf', 'print'))
      )
      
      
    },server = FALSE)
    
    # Synchronize train and test cursors
    observeEvent(input$train_selector,{
      updateSliderInput(session,'test_selector',
                        value= c(input$train_selector[2],input$test_selector[2]) )
    })
    observeEvent(input$test_selector,{
      updateSliderInput(session,'train_selector',
                        value= c(input$train_selector[1],input$test_selector[1]) )
    })
    
    #Message indicating that feature importance is not available for glm model
    output$feature_importance_glm_message <- renderUI({
      if (!is.na(v_glm$type_model) & is.na(v_random$type_model) & is.na(v_neural$type_model) &  is.na(v_decision_tree$type_model) & is.na(v_grad$type_model) & is.na(v_auto_ml$type_model)){
        sendSweetAlert(
          session = session,
          title = "Sorry ...",
          text = "Feature importance not available for generalized regression method !",
          type = "error"
          
          
        )
        
        argonH1("Feature importance not available for generalized regression method",display = 4)
      }
    })
    
    # Message indicating that results are not available if no model has been running
    output$message_compare_models_performances <- renderUI({
      
      if (ncol(table_forecast()[['results']]) <= ncol(data)){  
        sendSweetAlert(
          session = session,
          title = "",
          text = "Please run at least one algorithm to check model performances !",
          type = "error"
          
          
        )
        
        argonH1("Please run at least one algorithm to check model performances !",display = 4)
      }
    })
    
    # Message indicating that results are not available if no model has been running
    output$message_feature_importance <- renderUI({
      
      if (ncol(table_forecast()[['results']]) <= ncol(data)){  
        
        sendSweetAlert(
          session = session,
          title = "",
          text = "Please run at least one algorithm to check features importances !",
          type = "error"
          
          
        )
        
        argonH1("Please run at least one algorithm to check features importances !",display = 4)
      }
    })
    
    # When "Run all models!" button is clicked, send messageBox once all models have been trained
    observe({
      
      if (ncol(table_forecast()[['results']]) == ncol(data) + 4){
        
        sendSweetAlert(
          session = session,
          title = "The four machine learning models have been trained !",
          text = "Click ok to see results",
          type = "success"
        )
      }
    })
    
    # Define specific sever-side objects is H2O framework is selected
    if(framework == "h2o"){
      
      # Make all parameters correspond to cursors and radiobuttons choices when user click on "Run tuned models!" button
      observeEvent(input$train_all,{
        
        train_1$date <- input$train_selector[1]
        test_1$date <- input$test_selector[1]
        test_2$date <- input$test_selector[2]
        
        model$train_variables <- input$input_variables
        
        v_neural$type_model <- "ml_neural_network"
        v_grad$type_model <- "ml_gradient_boosted_trees"
        v_glm$type_model <- "ml_generalized_linear_regression"
        v_random$type_model <- "ml_random_forest"
        v_auto_ml$type_model <- NA
        
        parameter$family_glm <- input$glm_family
        parameter$glm_link <- input$glm_link
        parameter$intercept_term_glm <- input$intercept_term_glm
        parameter$reg_param_glm <- input$reg_param_glm
        parameter$alpha_param_glm <- input$alpha_param_glm
        parameter$max_iter_glm <- input$max_iter_glm
        
        
        parameter$num_tree_random_forest <- input$num_tree_random_forest
        parameter$subsampling_rate_random_forest <- input$subsampling_rate_random_forest
        parameter$max_depth_random_forest <-  input$max_depth_random_forest
        parameter$n_bins_random_forest <- input$n_bins_random_forest
        
        parameter$sample_rate_gbm <- input$sample_rate_gbm
        parameter$n_trees_gbm <- input$n_trees_gbm
        parameter$max_depth_gbm <- input$max_depth_gbm
        parameter$learn_rate_gbm <- input$learn_rate_gbm
        
        parameter$hidden_neural_net <- input$hidden_neural_net
        parameter$epochs_neural_net <- input$epochs_neural_net
        parameter$activation_neural_net <- input$activation_neural_net
        parameter$loss_neural_net <- input$loss_neural_net
        parameter$rate_neural_net <- input$rate_neural_net
        
      })
      
      # Make neural network parameters correspond to cursors and radiobuttons choices when user click on "Run neural network regression" button (and disable other models)
      observeEvent(input$run_neural_network,{
        
        train_1$date <- input$train_selector[1]
        test_1$date <- input$test_selector[1]
        test_2$date <- input$test_selector[2]
        model$train_variables <- input$input_variables
        
        v_neural$type_model <- "ml_neural_network"
        v_grad$type_model <- NA
        v_glm$type_model <- NA
        v_random$type_model <- NA
        v_auto_ml$type_model <- NA
        
        parameter$hidden_neural_net <- input$hidden_neural_net
        parameter$epochs_neural_net <- input$epochs_neural_net
        parameter$activation_neural_net <- input$activation_neural_net
        parameter$loss_neural_net <- input$loss_neural_net
        parameter$rate_neural_net <- input$rate_neural_net
        
      })
      
      # Make autoML parameter correspond to knobInput when user click on "Run Auto ML" button 
      observeEvent(input$run_auto_ml,{
        
        train_1$date <- input$train_selector[1]
        test_1$date <- input$test_selector[1]
        test_2$date <- input$test_selector[2]
        model$train_variables <- input$input_variables
        
        v_grad$type_model <- NA
        v_neural$type_model <- NA
        v_glm$type_model <- NA
        v_random$type_model <- NA
        v_auto_ml$type_model <- "ml_auto"
        
        parameter$run_time_auto_ml <-  input$run_time_auto_ml
        parameter$auto_ml_autorized_models <- input$auto_ml_autorized_models
        
      })
      
      # Define data train when time series option is not selected
      data_train_not_time_serie <- reactive({
        data %>% sample_frac(as.numeric(as.character(gsub("%","",input$percentage_selector)))*0.01)
      })
      
      # Define a list of object related to model results (specific for H2O framework)
      table_forecast <- reactive({
        
        # Make sure a value is set to checkbox_time_series checkbox 
        req(!is.null(input$checkbox_time_series))
        
        if (input$checkbox_time_series == TRUE){
          req(!is.null(test_1$date))
          data_train <- data.table()
          data_test <- data.table()
          data_results <- eval(parse(text = paste0("data[",input$time_serie_select_column,">'",test_1$date,"',][",input$time_serie_select_column,"< '",test_2$date,"',]")))
          
          
        }
        
        else if (input$checkbox_time_series == FALSE){
          
          
          req(!is.null(input$percentage_selector))
          
          data_train <- data_train_not_time_serie()
          data_test <- data %>% anti_join(data_train,by = colnames(data))
          data_results <- data_test
          
          
        }
        
        
        table_results <- data_results
        dl_auto_ml <- NA
        var_input_list <- c()
        for (i in 1:length(model$train_variables)){
          var_input_list <- c(var_input_list,model$train_variables[i])
          
        }
        
        
        # Verify that at least one explanatory variable is selected
        if (length(var_input_list) != 0){
          
          if (input$checkbox_time_series == TRUE){
            data_h2o_train <- as.h2o(eval(parse(text = paste0("data[",input$time_serie_select_column,"<='",test_1$date,"',][",input$time_serie_select_column,">='",train_1$date,"',][, !'",input$time_serie_select_column,"']"))))
            data_h2o_test <- as.h2o(eval(parse(text = paste0("data[",input$time_serie_select_column,">'",test_1$date,"',][",input$time_serie_select_column,"< '",test_2$date,"',][, !'",input$time_serie_select_column,"']"))))
          }
          
          else if (input$checkbox_time_series == FALSE){
            
            if (length(dates_variable_list()) >= 1){
              data_train <- eval(parse(text = paste0("data_train[, !'",dates_variable_list()[1] ,"']")))
              data_test <- eval(parse(text = paste0("data_test[, !'",dates_variable_list()[1],"']")))
            } 
            
            data_h2o_train <- as.h2o(data_train)
            data_h2o_test <- as.h2o(data_test)
          }
          
          
          # Calculation of glm predictions and associated calculation time
          if (!is.na(v_glm$type_model) & v_glm$type_model == "ml_generalized_linear_regression"){
            
            t1 <- Sys.time()
            fit <- h2o.glm(x = as.character(var_input_list),
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
            time_glm <- data.frame(`Training time` =  paste0(round(t2 - t1,1)," seconds"), Model = "Generalized linear regression")
            table_glm <- h2o.predict(fit,data_h2o_test) %>% as.data.table() %>% mutate(predict = round(predict,3)) %>% rename(`Generalized linear regression` = predict)
            table_results <- cbind(data_results,table_glm)%>% as.data.table()
            trained_models$glm <- fit

            
          }
          
          # Calculation of random forest predictions and associated calculation time
          if (!is.na(v_random$type_model) & v_random$type_model == "ml_random_forest"){
            
            
            
            t1 <- Sys.time()
            fit <- h2o.randomForest(x = as.character(var_input_list),
                                    y = y,
                                    training_frame = data_h2o_train,
                                    ntrees = parameter$num_tree_random_forest,
                                    sample_rate = parameter$subsampling_rate_random_forest,
                                    max_depth = parameter$max_depth_random_forest,
                                    nbins = parameter$n_bins_random_forest,
                                    seed = 123
            )
            t2 <- Sys.time()
            time_random_forest <- data.frame(`Training time` =  paste0(round(t2 - t1,1)," seconds"), Model = "Random forest")
            importance_random_forest <- h2o.varimp(fit) %>% as.data.table() %>% select(`variable`,scaled_importance) %>% mutate(model = "Random forest")
            table_random_forest<- h2o.predict(fit,data_h2o_test) %>% as.data.table() %>% mutate(predict = round(predict,3))  %>% rename(`Random forest` = predict)
            table_results <- cbind(data_results,table_random_forest)%>% as.data.table()
            trained_models$randomForest <- fit

          }
          
          # Calculation of neural network predictions and associated calculation time
          if (!is.na(v_neural$type_model) & v_neural$type_model == "ml_neural_network"){
            
            t1 <- Sys.time()
            fit <- h2o.deeplearning(x = as.character(var_input_list),
                                    y = y,
                                    training_frame = data_h2o_train,
                                    activation = parameter$activation_neural_net,
                                    loss = parameter$loss_neural_net,
                                    hidden = eval(parse(text = parameter$hidden_neural_net)) ,
                                    epochs = parameter$epochs_neural_net,
                                    rate = parameter$rate_neural_net,
                                    reproducible = T,
                                    seed = 123
            )
            t2 <- Sys.time()
            
            time_neural_network <- data.frame(`Training time` =  paste0(round(t2 - t1,1)," seconds"), Model = "Neural network")
            importance_neural_network <- h2o.varimp(fit) %>% as.data.table() %>% select(`variable`,scaled_importance) %>% mutate(model = "Neural network")
            table_neural_network <- h2o.predict(fit,data_h2o_test) %>% as.data.table() %>% mutate(predict = round(predict,3)) %>% rename(`Neural network` = predict)
            table_results <- cbind(data_results,table_neural_network)%>% as.data.table()
            trained_models$neuralNet <- fit
          }
          
          # Calculation of gradient boosted trees predictions and associated calculation time
          if (!is.na(v_grad$type_model) & v_grad$type_model == "ml_gradient_boosted_trees"){
            
            t1 <- Sys.time()
            fit <- h2o.gbm(x = as.character(var_input_list),
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
            time_gbm <- data.frame(`Training time` =  paste0(round(t2 - t1,1)," seconds"), Model = "Gradient boosted trees")
            importance_gbm <- h2o.varimp(fit) %>% as.data.table() %>% select(`variable`,scaled_importance) %>% mutate(model = "Gradient boosted trees")
            table_gradient_boosting <- h2o.predict(fit,data_h2o_test) %>% as.data.table() %>% mutate(predict = round(predict,3)) %>% rename(`Gradient boosted trees` = predict)
            table_results <- cbind(data_results,table_gradient_boosting)%>% as.data.table()
            trained_models$gradientBoost <- fit

          }
          
          # Calculation of autoML predictions (max calculation time has been set to 60 seconds)
          if (!is.na(v_auto_ml$type_model) & v_auto_ml$type_model == "ml_auto"){
            
            req(!is.null(parameter$auto_ml_autorized_models))
            
            dl_auto_ml <- h2o.automl(x = as.character(var_input_list),
                                     include_algos = parameter$auto_ml_autorized_models,
                                     y = y,
                                     training_frame = data_h2o_train,
                                     max_runtime_secs = parameter$run_time_auto_ml,
                                     seed = 123
                                     
            )
            
            
            
            time_auto_ml <- data.frame(`Training time` =  paste0(parameter$run_time_auto_ml," seconds"), Model = "Auto ML")
            table_auto_ml<- h2o.predict(dl_auto_ml,data_h2o_test) %>% as.data.table() %>% mutate(predict = round(predict,3))  %>% rename(`Auto ML` = predict)
            table_results <- cbind(data_results,table_auto_ml)%>% as.data.table()
            
          }
          
          # Assembly results of all models (some column might remain empty)
          if (!is.na(v_neural$type_model) & !is.na(v_grad$type_model) & !is.na(v_glm$type_model) & !is.na(v_random$type_model)){
            
            table_results <- cbind(data_results,table_glm,table_random_forest,table_neural_network,table_gradient_boosting)%>% as.data.table()
          }
          
        }
        
        table_training_time <- rbind(time_gbm,time_random_forest,time_glm,time_neural_network,time_auto_ml)
        table_importance <- rbind(importance_gbm,importance_random_forest,importance_neural_network) %>% as.data.table()
        
        # Used a list to access to different tables from only on one reactive objet
        list(data_train = data_train, data_test = data_test, traning_time = table_training_time, table_importance = table_importance, results = table_results,auto_ml_model = dl_auto_ml)
        
        
      })
      
      # Send WarningBox if Run auto ML" button is clicked and no model searching is authorized
      observeEvent(input$run_auto_ml,{
        if (is.null(parameter$auto_ml_autorized_models)){
          sendSweetAlert(session = session, title = "Warning !",
                         text = "Please authorize at least one model family to perform auto ML",
                         type = "warning"
          )
        }
      })
      
      # When "Run auto ML" button is clicked, send messageBox once searching time is reached
      observe({
        
        if("Auto ML" %in% colnames(table_forecast()[['results']])){
          list <- c(HTML(paste0("<b>Selected model:</b> ",table_forecast()[['auto_ml_model']]@leader@algorithm)))
          for (i in 1:ncol(table_forecast()[['auto_ml_model']]@leader@model$model_summary)){
            list <- rbind(list,HTML(paste0("<b>",colnames(table_forecast()[['auto_ml_model']]@leader@model$model_summary[i]),":</b> ",
                                           table_forecast()[['auto_ml_model']]@leader@model$model_summary[i])))
          }
          
          # The message box indicates best model family and all associated hyper-parameter values
          sendSweetAlert(
            session = session,
            title = "Auto ML algorithm succeed!",
            text = HTML(paste0(
              "<br>",
              list)),
            type = "success",
            html = TRUE
          )
        }
      })
    }


    observeEvent(input$save_models, {
        
        # Ensure table_forecast() exists
        req(table_forecast())
        
        # Create folder to save models if it doesn't exist
        if (!dir.exists("saved_models")) dir.create("saved_models")
        # Save GLM model if it exists
        if (!is.null(v_glm$type_model) && v_glm$type_model == "ml_generalized_linear_regression") {
            h2o.saveModel(trained_models$glm, path = "saved_models/glm", force = TRUE)
        }
        
        # Save Random Forest model if it exists
        if (!is.null(v_random$type_model) && v_random$type_model == "ml_random_forest") {
            h2o.saveModel(trained_models$randomForest, path = "saved_models/random_forest", force = TRUE)
        }
        
        # Save Neural Network model if it exists
        if (!is.null(v_neural$type_model) && v_neural$type_model == "ml_neural_network") {
            h2o.saveModel(trained_models$neuralNet, path = "saved_models/neural_network", force = TRUE)
        }
        
        # Save Gradient Boosted Trees model if it exists
        if (!is.null(v_grad$type_model) && v_grad$type_model == "ml_gradient_boosted_trees") {
            h2o.saveModel(trained_models$gradientBoost, path = "saved_models/gbm", force = TRUE)
        }
        showNotification("Models saved successfully!", type = "message", duration = 5)
        
        })

  }

list(server = server)


}