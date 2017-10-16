
#' Check the next problem for a particular language track
#'
#' Returns the next problem for a language track i.e. the next problem to be
#' submitted, or possibly the next problem to be fetched
#'
#' @param track_id a normalized, url-safe identifier for a language track.
#'  e.g. r, python, javascript etc
#'
#' @return Prints out current/next problem, silently returns problem slug
#'
#' @examples
#' \dontrun{
#' check_next_problem("r")
#' }
#' @export
check_next_problem <- function(track_id = "r") {

  path <- sprintf("v2/exercises/%s", track_id)

  url <- httr::modify_url(
    root_x,
    path = path,
    query = list(key = get_api_key())
  )


  resp <- httr::GET(url, config = user_agent)
  check_api_response(resp)

  x <- httr::content(resp)$problems[[1]]

  problem_dir <- file.path(get_exercism_path(), x$id)

  if (dir.exists(problem_dir)) {
    message(sprintf("Not submitted: %s (%s)", x$name, x$language))
  } else {
    message(sprintf("Next problem is: %s (%s)", x$name, x$language))
  }

  invisible(x$slug)

}


#' Fetch a problem for a particular language track
#'
#' Fetches the files for a problem via the Exercism API and writes them into
#' a new problem folder in the Exercism directory
#'
#' @param slug a normalized, url-safe identifier for a problem
#'  e.g. "hello-world"
#' @param track_id a normalized, url-safe identifier for a language track.
#'  e.g. r, python, javascript etc
#' @param force logical, indicating whether existing problem files should be
#'  overwritten
#' @param open logical, indicating whether to open the problem files immediately
#'  after fetching
#' @param start_testing logical, indicating whether to run `testthat::auto_test()`
#'  on the fetched problem's directory
#'
#' @return Prints confirmation message upon success
#'
#' @examples
#' \dontrun{
#' fetch_problem("hello-world", "r")
#' }
#' @export
fetch_problem <- function(slug, track_id = "r", force = FALSE, open = TRUE,
                          start_testing = FALSE) {

  path <- sprintf("tracks/%s/%s", track_id, slug)
  # Could also use "/v2/exercises/[track_id]/[slug]"

  url <- httr::modify_url(root_x, path = path)

  resp <- httr::GET(url, user_agent)

  check_api_response(resp)

  x <- httr::content(resp)$problem

  problem_dir <- file.path(get_exercism_path(), x$id)
  files <- x$files

  if (!dir.exists(problem_dir)) {
    dir.create(problem_dir, recursive = TRUE)
  } else if (force) {
    warning("Problem folder already exists, files will be overwritten.",
            call. = FALSE)
  } else {
    stop("Problem folder already exists")
  }

  for (i in 1:length(files)) {
    problem_file <- file.path(
      problem_dir,
      names(files)[i]
    )
    dir.create(dirname(problem_file), showWarnings = FALSE)
    write(
      files[[i]],
      file = problem_file
    )
  }

  message(sprintf("%s fetched for %s track", slug, track_id))

  if (open) {
    open_exercise(slug = slug, track_id = track_id)
  }

  if (start_testing && track_id == "r") {
    start_testing(slug = slug)
  }

  invisible(names(files))
}


#' Fetch the next problem for a particular language track
#'
#' Checks for the next problem via the Exercism API, and writes the files into
#' the folder in the Exercism directory
#'
#' @inheritParams fetch_problem
#' @param skip logical, indicating whether to skip the current (unsubmitted)
#'  problem and fetch the next problem
#'
#' @return Prints confirmation message upon success
#'
#' @examples
#' \dontrun{
#' fetch_next("r")
#' }
#' @export
fetch_next <- function(track_id = "r", skip = FALSE,
                       force = FALSE, open = TRUE,
                       start_testing = FALSE) {

  if (skip) {
    next_slug <- check_next_problem(track_id = track_id)
    skip_problem(track_id = track_id,
                 slug = next_slug)
  }

  path <- sprintf("v2/exercises/%s", track_id)

  url <- httr::modify_url(
    root_x,
    path = path,
    query = list(key = get_api_key())
  )

  resp <- httr::GET(url, user_agent)

  check_api_response(resp)

  x <- httr::content(resp)$problems[[1]]

  problem_dir <- file.path(get_exercism_path(), x$id)

  if (!dir.exists(problem_dir)) {
    fetch_problem(track_id = x$track_id, slug = x$slug, open = open)
  } else if (force) {
    fetch_problem(track_id = x$track_id, slug = x$slug,
                  force = TRUE, open = open)
  } else {
    warning(sprintf("Not submitted: %s (%s)", x$name, x$language),
            call. = FALSE)
  }
  
  if (start_testing && track_id == "r") {
    start_testing(slug = x$slug)
  }

}

#' Skip a problem for a language track
#'
#' Marks a problem as 'skipped' via the Exercism API
#'
#' @param slug a normalized, url-safe identifier for a problem
#'  e.g. "hello-world"
#' @param track_id a normalized, url-safe identifier for a language track.
#'  e.g. r, python, javascript etc
#'
#' @return Prints confirmation message upon success
#'
#' @examples
#' \dontrun{
#' skip_problem("bob", track_id = "r")
#' }
#' @export
skip_problem <- function(slug, track_id = "r") {

  path <- sprintf("api/v1/iterations/%s/%s/skip", track_id, slug)

  url <- httr::modify_url(root, path = path, query = list(key = get_api_key()))

  resp <- httr::POST(url, user_agent)

  check_api_response(resp)

  message(sprintf("%s skipped for %s track", slug, track_id))

}

#' Get track status from exercism.io
#'
#' Fetches current track status from exercism.io
#'
#' @param track_id a normalized, url-safe identifier for a language track.
#'  e.g. r, python, javascript etc
#'
#' @return Current track status from exercism.io
#'
#' @examples
#' \dontrun{
#' track_status("r")
#' }
#' @export
track_status <- function(track_id = "r") {

  path <- sprintf("api/v1/tracks/%s/status", track_id)

  url <- httr::modify_url(root, path = path, query = list(key = get_api_key()))

  resp <- httr::GET(url, user_agent)

  check_api_response(resp)

  x <- httr::content(resp)

  create_status(x)

}

create_status <- function(x) {

  check <- names(x) %in%
    c("track_id", "recent", "skipped", "submitted", "fetched")

  if (!all(check)) {
    stop("Status returned from exercism.io is invalid.")
  }

  status <- list(
    track_id = x$track_id,
    recent = x$recent,
    skipped = x$skipped,
    submitted = x$submitted,
    fetched = x$fetched
  )

  class(status) <- "status"
  status

}

#' Print status object
#'
#' @param x a status object (returned via \code{\link{track_status}}).
#' @param ... further arguments passed to or from other methods.
#'
#' @export
print.status <- function(x, ...) {
  utils::str(x)
}


#' Submit a solution to exercism.io
#'
#' Submits the specified solution to exercism.io
#'
#' @param path full path to the file containing the solution
#' @param comment comment to include with the submission
#' @param browse logical value indicating whether to navigate to the submission
#'   on exercism.io on completion
#'
#' @return Response from exercism.io
#'
#' @examples
#' \dontrun{
#' submit("~/exercism/r/hello-world/hello-world.R")
#' }
#' @export
submit <- function(path, comment = NULL, browse = FALSE) {

  data <- iteration(path, comment = comment)

  path <- "/api/v1/user/assignments"

  url <- httr::modify_url(root, path = path)

  resp <- httr::POST(url = url, user_agent,
                     body = data,
                     encode = "json")

  # should check response here and return a success/failure message
  check_api_response(resp)

  message(sprintf("%s for %s track has been sucessfully submitted",
                  data$problem, data$language))

  if (browse) {
    utils::browseURL(httr::content(resp)$url)
  }

  invisible(resp)

}


#' Navigate to an exercise solution on exercism.io
#'
#' @inheritParams fetch_problem
#'
#' @examples
#' \dontrun{
#' browse_solution("r", "hamming")
#' }
#' @export
browse_solution <- function(track_id = "r", slug) {

  url <- sprintf("http://exercism.io/exercises/%s/%s/readme", track_id, slug)

  utils::browseURL(url)
}


#' Navigate to an exercise description on exercism.io
#'
#' @inheritParams fetch_problem
#'
#' @examples
#' \dontrun{
#' browse_exercise("r", "leap")
#' }
#' @export
browse_exercise <- function(track_id = "r", slug) {

  url <- sprintf("http://exercism.io/exercises/%s/%s/readme", track_id, slug)

  utils::browseURL(url)
}
