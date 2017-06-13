# Set user agent
ua <- httr::user_agent('http://github.com/jonmcalder/exercism')

# Set root URL for exercism API
root <- 'http://exercism.io'

# Set root URL for exercism x-API
root_x <- 'http://x.exercism.io'



#' Set API key for exercism.io
#'
#' Set an environment variable for the provided exercism.io API key, and store
#' in .Renviron so that it can persist for future sessions.
#'
#' @param key API key for exercism.io
#'
#' @return Silently returns the result of the set operation, which will either
#'   be 'Updated' an existing key or 'Created' a new key.
#'
#' @export
set_api_key <- function(key) {

  Sys.setenv(EXERCISM_KEY = key)

  # Get path for HOME
  path <- Sys.getenv("HOME")
  if (nzchar(path)) {
    path <- normalizePath("~/")
  }

  Renviron_file <- file.path(path, ".Renviron")
  if (file.exists(Renviron_file)) {
    # Check if API key has been set before
    Renviron_lines <- readLines(Renviron_file)
    if (any(grepl("^EXERCISM_KEY=", Renviron_lines))) {
      Renviron_lines[grepl("^EXERCISM_KEY=", Renviron_lines)] = paste0("EXERCISM_KEY=", key)
      writeLines(Renviron_lines, Renviron_file)
      return(message(sprintf("Updated EXERCISM_KEY: %s", key)))
    }
  } else {
    # Create .Renviron if it doesn't already exist
    file.create(Renviron_file)
  }

  write(paste0("EXERCISM_KEY=", key), Renviron_file, append = TRUE)
  message(sprintf("Created EXERCISM_KEY: %s", key))
}

get_api_key <- function() {

  key <- Sys.getenv("EXERCISM_KEY")
  if (!nzchar(key)) {
    stop("Exercism API key not set. Please run set_api_key().")
  }
  key
}

#' Set path for exercism
#'
#' Set an environment variable for the provided exercism path, and store
#' in .Renviron so that it can persist for future sessions.
#'
#' @param path path to exercism folder
#'
#' @return Silently returns the result of the set operation, which will either
#'   be 'Updated' an existing key or 'Created' a new key.
#'
#' @export
set_exercism_path <- function(path = NULL) {

  if (is.null(path)) {
    if (.Platform$OS.type == "windows") {
      # to-do: update default path for Windows to be C:\Users\<username>\exercism
      path = normalizePath(
        file.path(Sys.getenv("HOMEDRIVE"),
                  Sys.getenv("HOMEPATH"),
                  "exercism"),
        winslash = "/"
      )
    } else {
      path = path.expand("~/exercism")
    }
  }

  Sys.setenv(EXERCISM_PATH = path)

  # Get path for HOME
  home_path <- Sys.getenv("HOME")
  if (nzchar(home_path)) {
    home_path <- normalizePath("~/")
  }

  Renviron_file <- file.path(home_path, ".Renviron")
  if (file.exists(Renviron_file)) {
    # Check if Exercism path has been set before
    Renviron_lines <- readLines(Renviron_file)
    if (any(grepl("^EXERCISM_PATH=", Renviron_lines))) {
      Renviron_lines[grepl("^EXERCISM_PATH=", Renviron_lines)] = paste0("EXERCISM_PATH=", path)
      writeLines(Renviron_lines, Renviron_file)
      return(message(sprintf("Updated EXERCISM_PATH: %s", path)))
    }
  } else {
    # Create .Renviron if it doesn't already exist
    file.create(Renviron_file)
  }

  write(paste0("EXERCISM_PATH=", path), Renviron_file, append = TRUE)
  message(sprintf("Created EXERCISM_PATH: %s", path))
}

get_exercism_path <- function() {

  path <- Sys.getenv("EXERCISM_PATH")
  if (!nzchar(path)) {
    stop("Exercism path key not set. Please run `set_exercism_path()`.")
  }
  path
}

#' Check API response
#'
#' Checks the http response code and type.
#'
#' @param response An http response from GET or POST
#'
#' @return Doesn't return a value, simply throws a warning or error if there
#' is something wrong with the response.
#'
check_API_response <- function(response) {

  # Check response code
  if (!(httr::status_code(response) %in% 200:230)) {

    parsed <- jsonlite::fromJSON(
      httr::content(response, "text"),
      simplifyVector = FALSE
    )

    stop(
      sprintf(
        "Exercism API request failed [%s]\n%s",
        httr::status_code(response),
        parsed$error
      ),
      call. = FALSE
    )
  }

  # Check response type
  if (httr::http_type(response) != "application/json") {
    warning("API did not return json", call. = FALSE)
  }

}
