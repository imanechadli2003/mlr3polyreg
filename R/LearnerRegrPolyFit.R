#' @title Polynomial Regression Learner
#' @name mlr_learners_regr.polyfit
#' @description
#' A Learner for polynomial regression using the polyreg package.
#' Calls polyreg::polyFit() for training and predict() for prediction.
#' @export
LearnerRegrPolyFit <- R6::R6Class("LearnerRegrPolyFit",
                                  inherit = mlr3::LearnerRegr,
                                  public = list(
                                    initialize = function() {
                                      super$initialize(
                                        id = "regr.polyfit",
                                        packages = "polyreg",
                                        feature_types = c("numeric"),
                                        predict_types = c("response"),
                                        param_set = paradox::ps(
                                          deg = paradox::p_int(
                                            lower = 1L,
                                            upper = 5L,
                                            default = 2L
                                          )
                                        )
                                      )
                                    }
                                  ),
                                  private = list(
                                    .train = function(task) {
                                      data <- as.data.frame(task$data())
                                      degree <- self$param_set$values$deg
                                      if (is.null(degree)) degree <- 2L
                                      polyreg::polyFit(data, deg = degree)
                                    },
                                    .predict = function(task) {
                                      newdata <- as.data.frame(task$data(cols = task$feature_names))
                                      newdata[[task$target_names]] <- 0
                                      response <- as.numeric(predict(self$model, newdata))
                                      mlr3::PredictionRegr$new(
                                        task = task,
                                        response = response
                                      )
                                    }
                                  )
)
