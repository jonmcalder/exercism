#' Start testing your solution
#'
#' Exercism- and R-specific wrapper for [testthat::auto_test()] that starts
#' testing your solution against the problem's test cases. Thus, you can improve
#' it iteratively, in a "[test-driven](http://exercism.io/how-it-works/newbie)"
#' manner.
#'
#' @inheritParams fetch_problem
#'
#' @return Prints test reports
#' @export
#'
#' @examples
#' \dontrun{
#'   start_testing("hello-world")
#' }
start_testing <- function(slug) {

  problem_dir <- file.path(get_exercism_path(), "r", slug)
  
  if (!dir.exists(problem_dir)) {
    stop(sprintf("Problem folder /r/%s/ not found.", slug))
  } else {
    testthat::auto_test(problem_dir, problem_dir)
  }  # hash = FALSE would be possible once github.com/hadley/testthat/pull/598 is released to CRAN
}
