#' Run tests
#' 
#' Wrapper for [testthat::auto_test()] that starts running the problem's test cases.
#'
#' @param slug a normalized, url-safe identifier for a problem
#'  e.g. "hello-world"
#'
#' @param track_id a normalized, url-safe identifier for a language track.
#'  e.g. r, python, javascript etc
#'
#' @return Prints test reports
#' @export
#'
#' @examples
#' \dontrun{
#'   run_tests("hello-world")
#' }
run_tests <- function(slug, track_id = "r") {

  problem_dir <- file.path(get_exercism_path(), track_id, slug)
  
  if (!dir.exists(problem_dir)) {
    stop(sprintf("Problem folder /%s/%s/ not found.", track_id, slug))
  } else {
    testthat::auto_test(problem_dir, problem_dir, hash = FALSE)
  }
}
