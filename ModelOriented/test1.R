# load packages and data
library(mlr)
library(DALEXtra)
library(modelStudio)
library(languageserver)

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

# pick observations
new_observation <- test[1:2, ]
rownames(new_observation) <- c("id1", "id2")

# make a studio for the model
modelStudio(explainer, new_observation)
