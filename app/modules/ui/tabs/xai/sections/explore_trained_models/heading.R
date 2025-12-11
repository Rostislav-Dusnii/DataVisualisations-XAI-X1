heading <- div(
  align = "center",
  argonButton(
    name = HTML("<font size='+1'>&nbsp;  Explore trained models </font>"),
    status = "info",
    size = "lg",
    toggle_modal = TRUE,
    modal_id = "modal_explore_trained_models"
  ),
  argonModal(
    id = "modal_explore_trained_models",
    title = HTML("<b>EXPLORE TRAINED MODELS</b>"),
    status = "info",
    gradient = TRUE,
    br(),
    HTML("<b>Experiment and study trained models parameters with XAI techniques.</b><br><br>"),
    HTML("<ul style='text-align:left;'>"),
    HTML("<li><b>Feature Importance:</b> Shows which features most influence the model’s predictions overall.</li>"),
    HTML("<li><b>Break Down [Local]:</b> Decomposes a single prediction into feature contributions for individual decisions.</li>"),
    HTML("<li><b>Shapley Values [Local]:</b> Fairly distributes prediction impact across features using game theory.</li>"),
    HTML("<li><b>Ceteris Paribus [Local]:</b> Visualizes how changing one feature affects the prediction while others stay fixed.</li>"),
    HTML("<li><b>Partial Dependence [Global]:</b> Shows average model response to a feature across the dataset.</li>"),
    HTML("<li><b>Accumulated Dependence [Global]:</b> Reveals smoother global patterns by accounting for feature distributions.</li>"),
    HTML("<li><b>Residuals vs Feature [Global]:</b> Plots prediction errors against feature values to detect bias or misfit.</li>"),
    HTML("<li><b>Feature Distribution [EDA]:</b> Displays how feature values are spread across the dataset.</li>"),
    HTML("<li><b>Target vs Feature [EDA]:</b> Compares actual target values to feature values to reveal correlations.</li>"),
    HTML("<li><b>Average Target vs Feature [EDA]:</b> Shows average target value per feature level to highlight trends.</li>"),
    HTML("</ul>")
  )
)
