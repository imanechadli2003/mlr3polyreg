test_that("LearnerRegrPolyFit train and predict work", {
  task <- mlr3::tsk("mtcars")
  lrn <- LearnerRegrPolyFit$new()
  lrn$train(task)
  preds <- lrn$predict(task)
  expect_true(inherits(preds, "PredictionRegr"))
  expect_equal(length(preds$response), task$nrow)
  expect_true(all(is.numeric(preds$response)))
})
