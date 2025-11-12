# Ensure reproducibility
set.seed(123)
framework <- "h2o"

# Don't print summarize() regrouping message
options(dplyr.summarise.inform = F)
