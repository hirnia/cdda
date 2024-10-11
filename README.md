## NOTE
Here, `cdda` is a toy package of a larger package `dda`. For full `dda` functions, visit github.com/wwiedermann.

## Overview

`dda`, Direction Dependence Analysis provides framework for analyzing competing linear models. A target model `y ~ x` is compared to an alternate (causally reversed) model `x ~ y` through a series of diagnostic tests. DDA framework supports causal model exploration and potential confounding detection through diagnostics with higher-order moments.

* `dda.indep()` independence property tests, including non‐linear correlation tests, Breusch–Pagan homoscedasticity tests, and the HSIC test 
* `dda.vardist()` variable distribution‐based tests, including D'Agostino and Anscombe–Glynn tests and bootstrap CIs on higher moment differences
* `dda.resdist()` residual distribution tests, including D'Agostino and Anscombe–Glynn tests and bootstrap CIs on higher moment differences
* `cdda.indep()` conditional (moderation) independence property tests, including non‐linear correlation tests, Breusch–Pagan homoscedasticity tests, and the HSIC test 
* `cdda.vardist()` conditional (moderation) variable distribution‐based tests, including D'Agostino and Anscombe–Glynn tests and bootstrap CIs on higher moment differences

Conditional (moderation) functions can be plotted as well where different moderator levels are visually displayed. 

If you are new to Direction Dependence Analysis concepts, the best place to start is the [Direction Dependence in Statistical Modeling: Methods of Analysis](https://onlinelibrary.wiley.com/doi/book/10.1002/9781119523024) text.

## Installation

`dda` is under beta testing development which has development version from GitHub (Coming Soon): 

```{r, eval = FALSE, echo = TRUE}
remotes::install_github("wwiedermann/dda")
```

### Development version

To get a bug fix or to use a feature from the development version, you can install the development version of `dda` from GitHub.

## Usage

```{r, eval = FALSE, echo = TRUE}
library(dda)
```


```{r, eval = FALSE, message = FALSE}
dda.indep(mpg ~ wt + hp + qsec, pred = "wt", data = mtcars)
cdda_cars <- cdda.indep(mpg ~ wt * hp + qsec, pred = "wt",
                        mod = "hp", diff = TRUE, data = mtcars)

summary(cdda_cars, hsic.diff = TRUE)
plot(cdda_cars, stat = "hsic.diff")
```

## Getting help

If you encounter a clear bug, please file an issue with a minimal reproducible example on GitHub. For questions and other discussion, please contact the package maintainer.

