
#' Open files for an exercism.io problem
#'
#' @inheritParams fetch_problem
#' @param change_wd logical, indicating whether the working directory should be
#'   set to the directory of the exercise being opened
#'
#' @export
#'
#' @examples
#' dontrun{
#' open_exercise("leap")
#' }
open_exercise <- function(slug, track_id = "r", change_wd = FALSE) {

  path_to_exercise <- file.path(get_exercism_path(), track_id, slug)

  files <- list.files(path_to_exercise, full.names = TRUE)

  lapply(files, file.edit)

  if (change_wd) {
    setwd(path_to_exercise)
    message("Changed working directory to ", path_to_exercise)
  }

  invisible(files)

}
