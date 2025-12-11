library(dplyr)
library(DALEX)
library(arenar)

X_train <- apartments
X_test <- apartmentsTest %>% select(-m2.price)
y_test <- apartmentsTest$m2.price

library(mlr)
task <- mlr::makeRegrTask(
  id = "R",
  data = X_train,
  target = "m2.price"
)

learner_kknn <- mlr::makeLearner("regr.kknn")
model_knn <- mlr::train(learner_kknn, task)

exp_gbm <- explain(model_knn, data=X_test, y=y_test, label="knn", predict_function = predict)
options(browser = "false")  # <-- add this
arena <- create_arena(live=TRUE) %>%
  # R
  push_model(exp_gbm) %>%
  # Add 10 first rows of testing dataset as observations
  push_observations(X_test[1:10, ]) %>%
  # Add apartmentsTest dataset for EDA
  push_dataset(apartmentsTest, target="m2.price", label="apartmentsTest") %>%
  # Run data source in live mode on port 9293
  run_server(port=9293)

print(arena)