library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(mlr3polyreg)
library(ggplot2)

# 2 jeux de données
task1 <- tsk("mtcars")

task2 <- tsk("california_housing")
task2$select(c("latitude", "longitude", "housing_median_age",
               "total_rooms", "population",
               "households", "median_income"))

tasks <- list(task1, task2)

# 4 Learners
learners <- list(
  LearnerRegrPolyFit$new(),
  lrn("regr.featureless"),
  lrn("regr.cv_glmnet"),
  auto_tuner(
    learner = lrn("regr.kknn", k = to_tune(1, 10)),
    resampling = rsmp("cv", folds = 3),
    measure = msr("regr.mse"),
    tuner = tnr("grid_search"),
    terminator = trm("evals", n_evals = 10)
  )
)

# CV 5 blocs
resampling <- rsmp("cv", folds = 5)

# Benchmark
design <- benchmark_grid(tasks, learners, resampling)
bmr <- benchmark(design)

# Résultats
results <- bmr$score(msr("regr.mse"))

# Graphique
ggplot(results, aes(x = regr.mse, y = learner_id)) +
  geom_point() +
  facet_grid(task_id ~ .) +
  labs(x = "MSE", y = "Algorithm")
