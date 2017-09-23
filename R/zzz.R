# Get existing config from .exercism.json
# (will be present if exercism CLI has been installed and configured)

get_existing_config <- function() {

  if (.Platform$OS.type == "windows") {
    config_path <- file.path(
      normalizePath(
        file.path(
          Sys.getenv("HOMEDRIVE"),
          Sys.getenv("HOMEPATH")
        ),
        winslash = "/"),
      ".exercism.json")
  } else {
    config_path <- path.expand("~/.exercism.json")
  }

  if (file.exists(config_path)) {
    packageStartupMessage("Found existing exercism config")
    jsonlite::fromJSON(config_path)
  } else {
    list(apiKey = "", dir = "") # nolint
  }

}

# Check for EXERCISM_PATH and EXERCISM_KEY
# Set automatically if possible
# Otherwise show message(s)

.onLoad <- function(libname, pkgname){

  key <- Sys.getenv("EXERCISM_KEY")
  path <- Sys.getenv("EXERCISM_PATH")

  if (!nzchar(key) || !nzchar(path)) {
    config <- get_existing_config()

    if (nzchar(config$apiKey)) { # nolint
      key <- config$apiKey # nolint
      set_api_key(key, force = TRUE)
    }
    if (nzchar(config$dir)) {
      path <- normalizePath(config$dir, "/")
      set_exercism_path(path, force = TRUE)
    }

    if (!nzchar(key)) {
      packageStartupMessage("Exercism API key not set. Please log into 
        exercism.io/account/key, copy the key and run set_api_key().")
    }
    if (!nzchar(path)) {
      packageStartupMessage("Exercism path not set. Please run 
        set_exercism_path(\"...\") with a directory path.")
    }

  }

}
