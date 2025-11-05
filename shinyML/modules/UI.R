create_shinyML_UI <- function(data, y) {

 framework <- "h2o"
  ## ----------------- Navigation Bar -----------------
  argonNav <- argonDashNavbar(
    argonDropNav(
      title = HTML(paste0("shiny<font color='orange'>ML</font>")), 
      src = "https://www.zupimages.net/up/20/39/ql8k.jpg", 
      orientation = "left"
    )
  )

  ## ----------------- Footer -----------------
  argonFooter <- argonDashFooter(
    copyrights = "@shinyML, 2020",
    src = "https://jeanbertinr.github.io/shinyMLpackage/",
    argonFooterMenu(
      argonFooterItem("GitHub", src = "https://github.com/JeanBertinR/shinyML"),
      argonFooterItem("CRAN", src = "https://cran.r-project.org/web/packages/shinyML/index.html")
    )
  )

  ## ----------------- DashHeader: Info Cards -----------------
  dashheader_framework <- argonDashHeader(
    gradient = TRUE,
    color = "danger",
    separator = FALSE,
    argonRow(
      argonColumn(width = "20%",
                  argonInfoCard(value = "Regression", gradient = TRUE, width = 12,
                                title = "Machine learning task",
                                icon = icon("chart-bar"), 
                                icon_background = "red",
                                background_color = "lightblue"
                  )
      ),
      argonColumn(width = "20%", uiOutput("framework_used")),
      argonColumn(width = "20%", uiOutput("framework_memory")),
      argonColumn(width = "20%", uiOutput("framework_cpu")),
      argonColumn(width = "20%", uiOutput("dataset_infoCard"))
    )
  )

  ## ----------------- DashHeader: Explore Input Data -----------------
  dashheader_explore_input <- argonDashHeader(
    gradient = FALSE,
    color = "info",
    separator = FALSE,
    div(align = "center",
        argonButton(
          name = HTML("<font size='+1'>&nbsp;  Explore input data </font>"),
          status = "info",
          icon = icon("chart-area"),
          size = "lg",
          toggle_modal = TRUE,
          modal_id = "modal_explore_input_data"
        ),
        argonModal(
          id = "modal_explore_input_data",
          title = HTML("<b>EXPLORE INPUT DATA</b>"),
          status = "info",
          gradient = TRUE,
          br(),
          HTML("<b>Before running machine learning models, it can be useful to inspect each variable distribution and dependencies between explanatory variables.</b>"),
          br(),br(),
          icon("tools"), icon("tools"), icon("tools"),
          br(),br(),
          HTML("This section allows you to plot variable variations, check classes, histograms, and correlation matrix.<br><br>Some variables may be removed from training if highly correlated.")
        )
    ),
    br(),
    argonRow(
      argonColumn(width = 9,
                  argonCard(width = 12, hover_lift = TRUE, shadow = TRUE,
                            argonTabSet(
                              width = 12,
                              id = "tab_input_data",
                              card_wrapper = TRUE,
                              horizontal = TRUE,
                              circle = FALSE,
                              size = "sm",
                              iconList = list(argonIcon("cloud-upload-96"), argonIcon("bell-55"), argonIcon("calendar-grid-58"), argonIcon("calendar-grid-58")),
                              argonTab(
                                tabName = "Explore dataset",
                                active = TRUE,
                                argonRow(
                                  argonColumn(width = 6, div(align = "center", uiOutput("X_axis_explore_dataset"))),
                                  argonColumn(width = 6, div(align = "center",
                                                             selectInput(inputId = "y_variable_input_curve",
                                                                         label = "Y-axis variable",
                                                                         choices = colnames(data),
                                                                         selected = y)))
                                ),
                                br(), br(), br(),
                                withSpinner(plotlyOutput("explore_dataset_chart", width = "100%", height = "120%"))
                              ),
                              argonTab(
                                tabName = "Variables Summary",
                                active = FALSE,
                                fluidRow(
                                  argonColumn(width = 4, br(), br(),
                                              withSpinner(DTOutput("variables_class_input", height = "100%", width = "100%"))
                                  ),
                                  argonColumn(width = 8,
                                              div(align = "center",
                                                  radioButtons(inputId = "input_var_graph_type",
                                                               label = "",
                                                               choices = c("Histogram","Boxplot","Autocorrelation"),
                                                               selected = "Histogram", inline = TRUE)
                                              ),
                                              div(align = "center", uiOutput("message_autocorrelation")),
                                              withSpinner(plotlyOutput("variable_boxplot", height = "100%", width = "100%"))
                                  )
                                )
                              ),
                              argonTab(
                                tabName = "Correlation matrix",
                                active = FALSE,
                                withSpinner(plotlyOutput("correlation_matrix", height = "100%", width = "100%"))
                              )
                            )
                  )
      ),
      argonColumn(width = 3,
                  argonCard(width = 12, src = NULL, hover_lift = TRUE, shadow = TRUE,
                            div(align = "center",
                                argonColumn(width = 6, uiOutput("Time_series_checkbox")),
                                argonColumn(width = 6, uiOutput("time_series_column")),
                                uiOutput("Variables_input_selection"),
                                uiOutput("slider_time_series_train"),
                                uiOutput("slider_time_series_test"),
                                uiOutput("slider_percentage"),
                                uiOutput("message_nrow_train_dataset")
                            )
                  )
      )
    )
  )

  ## ----------------- DashHeader: Explore Results -----------------
  dashheader_explore_results <- argonDashHeader(gradient = TRUE,
                                                color = "primary",
                                                separator = FALSE,
                                                div(align = "center",
                                                    argonButton(
                                                      name = HTML("<font size='+1'>&nbsp; Explore results</font>"),
                                                      status = "primary",
                                                      icon = icon("list-ol"),
                                                      size = "lg",
                                                      toggle_modal = TRUE,
                                                      modal_id = "modal_explore_results"
                                                    ),
                                                    argonModal(
                                                      id = "modal_explore_results",
                                                      title = HTML("<b>EXPLORE RESULTS</b>"),
                                                      status = "primary",
                                                      gradient = TRUE,
                                                      br(),
                                                      HTML("<b>Once machine learning models have been lauched, this section can be used to compare their performances on the testing dataset</b>"),
                                                      br(),br(),
                                                      icon("tools"),icon("tools"),icon("tools"),
                                                      br(),br(),
                                                      HTML("You can check confusion matrices to get classification results for each model or have an overview of error metric in 'Compare models performances' tab.<br><br>
                                                           Please note that feature importances of each model are available in the corresponding tab.")
                                                    )
                                                ),
                                                br(),
                                                argonRow(
                                                  argonCard(width = 12,
                                                            title = "Predictions on test period",
                                                            src = NULL,
                                                            hover_lift = TRUE,
                                                            shadow = TRUE,
                                                            icon = icon("cogs"),
                                                            status = "danger",
                                                            argonTabSet(
                                                              width = 12,
                                                              id = "results_models",
                                                              card_wrapper = TRUE,
                                                              horizontal = TRUE,
                                                              circle = FALSE,
                                                              size = "sm",
                                                              iconList = list(argonIcon("cloud-upload-96"), argonIcon("bell-55"), argonIcon("calendar-grid-58"),argonIcon("calendar-grid-58")),
                                                              argonTab(
                                                                tabName = "Result charts on test period",
                                                                active = TRUE,
                                                                withSpinner(dygraphOutput("output_curve",  width = "100%")),
                                                                br(),
                                                                div(align = "center",
                                                                    switchInput(label = "Bar chart mode",inputId = "bar_chart_mode",value = TRUE)
                                                                )
                                                              ),
                                                              argonTab(
                                                                tabName = "Compare models performances",
                                                                active = FALSE,
                                                                div(align = "center",
                                                                    br(),
                                                                    br(),
                                                                    uiOutput("message_compare_models_performances")
                                                                ),
                                                                withSpinner(DTOutput("score_table"))
                                                              ),
                                                              argonTab(tabName = "Feature importance",
                                                                       active = FALSE,
                                                                       div(align = "center",
                                                                           br(),
                                                                           br(),
                                                                           uiOutput("message_feature_importance"),
                                                                           uiOutput("feature_importance_glm_message")),
                                                                       withSpinner(plotlyOutput("feature_importance",height = "100%"))
                                                                       
                                                              ),
                                                              argonTab(tabName = "Table of results",
                                                                       active = FALSE,
                                                                       withSpinner(DTOutput("table_of_results"))
                                                              )
                                                            ),
                                                            br(),
                                                            br(),
                                                            actionButton("save_models","Save Trained Models",style = 'color:white; background-color:red; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                  )
                                                )
  )

  dashheader_select_parameters <- NULL
    Sys.setenv(http_proxy="")
    Sys.setenv(http_proxy_user="")
    Sys.setenv(https_proxy_user="")
    h2o.init()
    h2o::h2o.no_progress()
    cluster_status <- h2o.clusterStatus()
    
    dashheader_select_parameters <- argonDashHeader(gradient = TRUE,
                                                    color = "default",
                                                    separator = FALSE,
                                                    div(align = "center",
                                                        argonButton(
                                                          name = HTML("<font size='+1'>&nbsp; Configure parameters and run models</font>"),
                                                          status = "default",
                                                          icon = icon("tools"),
                                                          size = "lg",
                                                          toggle_modal = TRUE,
                                                          modal_id = "modal_configure_parameters"
                                                        ),
                                                        argonModal(
                                                          id = "modal_configure_parameters",
                                                          title = HTML("<b>CONFIGURE PARAMETERS</b>"),
                                                          status = "default",
                                                          gradient = TRUE,
                                                          br(),
                                                          HTML("<b>Compare different machine learning techniques with your own hyper-parameters configuration.</b>"),
                                                          br(),br(),
                                                          icon("tools"),icon("tools"),icon("tools"),
                                                          br(),br(),
                                                          HTML("You are free to select hyper-parameters configuration for each machine learning model using different cursors.<br><br> 
                                                               Each model can be lauched separately by cliking to the corresponding button; you can also launch all models simultaneously using 'Run all models!'button<br><br>
                                                               Please note that autoML algorithm will automatically find the best algorithm to suit your regression task: 
                                                               the user will be informed of the machine learning technique used and know which hyper-parameters should be configured.
                                                               ")
                                                        )
                                                    ),
                                                    br(),
                                                    argonRow(
                                                      argonColumn(width = 6,div(align = "center",uiOutput("h2o_cluster_mem"))),
                                                      argonColumn(width = 6,div(align = "center",uiOutput("h2o_cpu")))
                                                    ),
                                                    argonRow(
                                                      argonCard(width = 3,
                                                                icon = icon("sliders"),
                                                                status = "success",
                                                                title = "Generalized linear regression",
                                                                div(align = "center",
                                                                    argonRow(
                                                                      argonColumn(width = 6,
                                                                                  radioButtons(label = "Family",inputId = "glm_family",choices = c("gaussian","poisson", "gamma","tweedie"),selected = "gaussian")
                                                                      ),
                                                                      argonColumn(width = 6,
                                                                                  radioButtons(label = "Link",inputId = "glm_link",choices = c("identity","log"),selected = "identity"),
                                                                                  switchInput(label = "Intercept term",inputId = "intercept_term_glm",value = TRUE,width = "auto")
                                                                      )
                                                                    ),
                                                                    sliderInput(label = "Lambda",inputId = "reg_param_glm",min = 0,max = 10,value = 0),
                                                                    sliderInput(label = "Alpha (0:Ridge <-> 1:Lasso)",inputId = "alpha_param_glm",min = 0,max = 1,value = 0.5),
                                                                    sliderInput(label = "Maximum iteraions",inputId = "max_iter_glm",min = 50,max = 300,value = 100),
                                                                    actionButton("run_glm","Run glm",style = 'color:white; background-color:green; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                                )
                                                      ),
                                                      argonCard(width = 3,
                                                                icon = icon("sliders"),
                                                                status = "danger",
                                                                title = "Random Forest",
                                                                div(align = "center",
                                                                    sliderInput(label = "Number of trees",min = 1,max = 100, inputId = "num_tree_random_forest",value = 50),
                                                                    sliderInput(label = "Subsampling rate",min = 0.1,max = 1, inputId = "subsampling_rate_random_forest",value = 0.6),
                                                                    sliderInput(label = "Max depth",min = 1,max = 50, inputId = "max_depth_random_forest",value = 20),
                                                                    sliderInput(label = "Number of bins",min = 2,max = 100, inputId = "n_bins_random_forest",value = 20),
                                                                    actionButton("run_random_forest","Run random forest",style = 'color:white; background-color:red; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                                )
                                                      ),
                                                      argonCard(width = 3,
                                                                icon = icon("sliders"),
                                                                status = "primary",
                                                                title = "Neural network",
                                                                div(align = "center",
                                                                    argonRow(
                                                                      argonColumn(width = 6,
                                                                                  radioButtons(label = "Activation function",inputId = "activation_neural_net",choices = c( "Rectifier", "Maxout","Tanh", "RectifierWithDropout", "MaxoutWithDropout","TanhWithDropout"),selected = "Rectifier")
                                                                      ),
                                                                      argonColumn(width = 6,
                                                                                  radioButtons(label = "Loss function",inputId = "loss_neural_net",choices = c("Automatic", "Quadratic", "Huber", "Absolute", "Quantile"),selected = "Automatic")
                                                                      )
                                                                    ),
                                                                    textInput(label = "Hidden layers",inputId = "hidden_neural_net",value = "c(200,200)"),
                                                                    sliderInput(label = "Epochs",min = 10,max = 100, inputId = "epochs_neural_net",value = 10),
                                                                    sliderInput(label = "Learning rate",min = 0.001,max = 0.1, inputId = "rate_neural_net",value = 0.005),
                                                                    actionButton("run_neural_network","Run neural network",style = 'color:white; background-color:darkblue; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                                )
                                                                
                                                      ),
                                                      argonCard(width = 3,
                                                                icon = icon("sliders"),
                                                                status = "warning",
                                                                title = "Gradient boosting",
                                                                div(align = "center",
                                                                    sliderInput(label = "Max depth",min = 1,max = 20, inputId = "max_depth_gbm",value = 5),
                                                                    sliderInput(label = "Number of trees",min = 1,max = 100, inputId = "n_trees_gbm",value = 50),
                                                                    sliderInput(label = "Sample rate",min = 0.1,max = 1, inputId = "sample_rate_gbm",value = 1),
                                                                    sliderInput(label = "Learn rate",min = 0.1,max = 1, inputId = "learn_rate_gbm",value = 0.1),
                                                                    actionButton("run_gradient_boosting","Run gradient boosting",style = 'color:white; background-color:orange; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                                )
                                                      )
                                                    ),
                                                    argonRow(
                                                      argonColumn(width = 6,
                                                                  argonCard(width = 12,
                                                                            icon = icon("cogs"),
                                                                            status = "warning",
                                                                            title = "Compare all models",
                                                                            div(align = "center",
                                                                                argonH1("Click this button to run all model simultaneously",display = 4),
                                                                                argonH1(HTML("<small><i> The four models will be runed with the parameters selected above</i></small>"),display = 4), 
                                                                                br(),
                                                                                br(),
                                                                                actionBttn(label = "Run all models !",inputId = "train_all",color = "primary", icon = icon("cogs",lib = "font-awesome")),
                                                                                br()
                                                                            )
                                                                  )
                                                      ),
                                                      argonColumn(width = 6,
                                                                  argonCard(width = 12,icon = icon("cogs"),status = "warning", title = "Auto Machine Learning",
                                                                            div(align = "center",
                                                                                prettyCheckboxGroup(
                                                                                  inputId = "auto_ml_autorized_models",
                                                                                  label = HTML("<b>Authorized searching</b>"), 
                                                                                  choices = c("DRF", "GLM", "XGBoost", "GBM", "DeepLearning"),
                                                                                  selected = c("DRF", "GLM", "XGBoost", "GBM", "DeepLearning"),
                                                                                  icon = icon("check-square-o"), 
                                                                                  status = "primary",
                                                                                  inline = TRUE,
                                                                                  outline = TRUE,
                                                                                  animation = "jelly"
                                                                                ),
                                                                                br(),
                                                                                knobInput(inputId = "run_time_auto_ml",label = HTML("<b>Max running time (in seconds)</b>"),value = 15,min = 10,max = 60,
                                                                                          displayPrevious = TRUE, lineCap = "round",fgColor = "#428BCA",inputColor = "#428BCA"
                                                                                ),
                                                                                actionButton("run_auto_ml","Run auto ML",style = 'color:white; background-color:red; padding:4px; font-size:120%',icon = icon("cogs",lib = "font-awesome"))
                                                                            )
                                                                  )
                                                      )
                                                    )
    )

  argonHeader <- argonColumn(
    width = "100%",
    dashheader_framework,
    dashheader_explore_input,
    dashheader_select_parameters,
    dashheader_explore_results
  )

  list(navbar = argonNav, footer = argonFooter, header = argonHeader)
}
