
#' Check the next problem for a particular language track
#'
#' Returns the next problem for a language track i.e. the next problem to be
#' submitted, or possibly the next problem to be fetched
#'
#' @param trackID a normalized, url-safe identifier for a language track. e.g. r, python, javascript etc
#'
#' @return Prints out current/next problem, silently returns problem slug
#'
#' @export
check_next_problem <- function(trackID = "r") {

  path <- sprintf('/v2/exercises/%s', trackID)

  url <- httr::modify_url(root_x, path = path, query = list(key = get_api_key()))

  resp <- httr::GET(url, ua)

  check_API_response(resp)

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
#' @param trackID a normalized, url-safe identifier for a language track. e.g. r, python, javascript etc
#' @param slug a normalized, url-safe identifier for a problem e.g. "hello-world"
#' @param force logical, indicating whether existing problem files should be overwritten
#'
#' @return Prints confirmation message upon success
#'
#' @export
fetch_problem <- function(trackID = "r", slug, force = FALSE) {

  path <- sprintf('/tracks/%s/%s', trackID, slug)
  # Could also use '/v2/exercises/[trackID]/[slug]'

  url <- httr::modify_url(root_x, path = path)

  resp <- httr::GET(url, ua)

  check_API_response(resp)

  x <- httr::content(resp)$problem

  problem_dir <- file.path(get_exercism_path(), x$id)
  files <- x$files

  if (!dir.exists(problem_dir)) {
    dir.create(problem_dir, recursive = TRUE)
  } else if (force) {
    warning("Problem folder already exists, files will be overwritten.", call. = FALSE)
  } else {
    stop("Problem folder already exists")
  }

  for (i in 1:length(files)) {
    problem_file <- file.path(
      problem_dir,
      names(files)[i]
    )
    dir.create(dirname(problem_file))
    write(
      files[[i]],
      file = problem_file
    )
  }

  message(sprintf("%s fetched for %s track", slug, trackID))
}


#' Fetch the next problem for a particular language track
#'
#' Checks for the next problem via the Exercism API, and writes the files into
#' the folder in the Exercism directory
#'
#' @param trackID a normalized, url-safe identifier for a language track. e.g. r, python, javascript etc
#' @param skip logical, indicated whether existing problem files should be overwritten
#' @param force logical, indicating whether existing problem files should be overwritten
#'
#' @return Prints confirmation message upon success
#'
#' @export
fetch <- function(trackID = "r", skip = FALSE, force = FALSE) {

  if (skip) {
    skip_problem(trackID = trackID, slug = check_next_problem(trackID = trackID))
  }

  path <- sprintf('/v2/exercises/%s', trackID)

  url <- httr::modify_url(root_x, path = path, query = list(key = get_api_key()))

  resp <- httr::GET(url, ua)

  check_API_response(resp)

  x <- httr::content(resp)$problems[[1]]

  problem_dir <- file.path(get_exercism_path(), x$id)

  if (!dir.exists(problem_dir)) {
    fetch_problem(trackID = x$track_id, slug = x$slug)
  } else if (force) {
    fetch_problem(trackID = x$track_id, slug = x$slug, force = TRUE)
  } else {
    warning(sprintf("Not submitted: %s (%s)", x$name, x$language),
            call. = FALSE)
  }

}

#' Skip a problem for a language track
#'
#' Marks a problem as 'skipped' via the Exercism API
#'
#' @param trackID a normalized, url-safe identifier for a language track. e.g. r, python, javascript etc
#' @param slug a normalized, url-safe identifier for a problem e.g. "hello-world"
#'
#' @return Prints confirmation message upon success
#'
#' @export
skip_problem <- function(trackID = "r", slug) {

  path <- sprintf('api/v1/iterations/%s/%s/skip', trackID, slug)

  url <- httr::modify_url(root, path = path, query = list(key = get_api_key()))

  resp <- httr::POST(url, ua)

  check_API_response(resp)

  message(sprintf(sprintf("%s skipped for %s track", slug, trackID)))

}

#' Get status from exercism.io
#'
#' Fetches current status from exercism.io
#'
#' @param trackID a normalized, url-safe identifier for a language track. e.g. r, python, javascript etc
#'
#' @return Current status from exercism.io
#'
#' @export
status <- function(trackID = "r") {

  path <- sprintf("api/v1/tracks/%s/status", trackID)

  url <- httr::modify_url(root, path = path, query = list(key = get_api_key()))

  resp <- httr::GET(url, ua)

  check_API_response(resp)

  x <- httr::content(resp)

  # To-do: tidy up/parse status for output
  # str(x)

}
