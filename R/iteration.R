
#' Create a problem iteration
#'
#' This is a helper function which is called by [submit()]. It shouldn't ever need to be called directly.
#'
#' @inheritParams submit
#'
#' @return A (data) list containing the code and various problem metadata
#'
#' @examples
#' iteration("~/exercism/r/hello-world/hello-world.R")
#' @noRd
iteration <- function(filepath, comment = NULL) {

  # if not absolute, then expand from working directory
  # if not on exercism path then error
  # if language and extension do not match then error
  if (is.null(filepath)) {
    path_to_solution <- rstudioapi::getSourceEditorContext()$path
  }
  else if (R.utils::isAbsolutePath(filepath)) {
    path_to_solution <- filepath
  }
  else {
    path_to_solution <- file.path(getwd(), filepath)
  }

  # supported file extensions
  exts <- c(R = "r", r = "r", py = "python", js = "javascript")

  assertthat::assert_that(
    file.exists(path_to_solution),
    msg = "Filepath does not exist."
  )
  assertthat::assert_that(
    tools::file_ext(path_to_solution) != "",
    msg = "Filepath specifies a directory. Please specify a file."
  )
  assertthat::assert_that(
    grepl(path.expand(get_exercism_path()), path.expand(path_to_solution)),
    msg = "Filepath does not match the exercism path."
  )

  language_problem <- tail(unlist(strsplit(dirname(path_to_solution),
                                           .Platform$file.sep)), 2)

  assertthat::assert_that(
    language_problem[1] %in% exts,
    msg = "Sorry, that language track is not supported at this time."
  )
  assertthat::assert_that(
    exts[[tools::file_ext(path_to_solution)]] == language_problem[1],
    msg = "File extension does not match the language identifier present on the
    filepath. Please check the filepath."
  )

  code <- paste(readLines(path_to_solution), collapse = "\n")
  solution_code <- list(code)
  names(solution_code) <- basename(path_to_solution)

  data <- list(
    key = get_api_key(),
    code = NULL,
    dir = dirname(path_to_solution),
    language = language_problem[1],
    problem = language_problem[2],
    solution = solution_code,
    comment = comment
  )

  data
}
