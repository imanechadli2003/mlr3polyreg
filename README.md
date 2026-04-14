# mlr3polyreg

[![R-CMD-check](https://github.com/imanechadli2003/mlr3polyreg/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/imanechadli2003/mlr3polyreg/actions/workflows/R-CMD-check.yaml)

An mlr3 learner for Polynomial Regression using the polyreg package.

## Installation

```r
remotes::install_github("imanechadli2003/mlr3polyreg")
```

## Usage

```r
library(mlr3polyreg)

task <- mlr3::tsk("mtcars")
lrn <- LearnerRegrPolyFit$new()
lrn$train(task)
predictions <- lrn$predict(task)
print(predictions)
```

## Related work

- [Course wiki](https://github.com/tdhock/2026-01-aa-grande-echelle/wiki/projets)
- [polyreg package](https://cran.r-project.org/package=polyreg)

