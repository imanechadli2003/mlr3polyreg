library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(ggplot2)

pkgload::load_all()

# 2 jeux de données
task1 <- tsk("mtcars")

task2 <- tsk("california_housing")
task2$select(c("latitude", "longitude", "housing_median_age",
               "total_rooms", "population",
               "households", "median_income"))

tasks <- list(task1, task2)

# 4 Learners
poly_lrn <- LearnerRegrPolyFit$new()
poly_lrn$param_set$values$deg <- 1L

learners <- list(
  poly_lrn,
  lrn("regr.featureless"),
  lrn("regr.cv_glmnet"),
  auto_tuner(
    learner = lrn("regr.kknn", k = to_tune(1, 10)),
    resampling = rsmp("cv", folds = 3),
    measure = msr("regr.rmse"),
    tuner = tnr("grid_search"),
    terminator = trm("evals", n_evals = 10)
  )
)

# CV 5 blocs
resampling <- rsmp("cv", folds = 5)

# Benchmark
design <- benchmark_grid(tasks, learners, resampling)
bmr <- benchmark(design)

# Résultats avec RMSE
results <- bmr$score(msr("regr.rmse"))

# Graphique
p <- ggplot(results, aes(x = regr.rmse, y = learner_id)) +
  geom_point() +
  facet_grid(task_id ~ ., scales = "free_x") +
  labs(x = "RMSE", y = "Algorithm", title = "Benchmark Results")

print(p)
ggsave("benchmark_plot.png", p, width = 8, height = 6)
