#' Run tests against your solution automatically
#' 
#' Exercism-specific wrapper for [testthat::auto_test()] that starts running the
#' problem's test cases against your solution. Thus, you can improve it iteratively, in a "[test-driven](http://exercism.io/how-it-works/newbie)" manner.
#'
#' @inheritParams fetch_problem
#'
#' @return Prints test reports
#' @export
#'
#' @examples
#' \dontrun{
#'   autotest("hello-world")
#' }
autotest <- function(slug, track_id = "r") {

  problem_dir <- file.path(get_exercism_path(), track_id, slug)
  
  if (!dir.exists(problem_dir)) {
    stop(sprintf("Problem folder /%s/%s/ not found.", track_id, slug))
  } else {
    testthat::auto_test(problem_dir, problem_dir)
  }  # hash = FALSE would be possible once github.com/hadley/testthat/pull/598 is released to CRAN
}
