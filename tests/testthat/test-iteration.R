context("iteration")

current_path <- try(get_exercism_path(), TRUE)

on.exit({
  # Remove files on exit
  lapply(file_list, unlink, recursive = TRUE, force = TRUE)
  lapply(dir_list, unlink, recursive = TRUE, force = TRUE)
  lapply(dirname(dir_list), unlink, recursive = TRUE, force = TRUE)
  
  if (class(current_path) != "try-error") {
    set_exercism_path(current_path, force = TRUE)
  }
})

set_exercism_path("~", force = TRUE)

ex_path <- get_exercism_path()
dir_list <- c(file.path(ex_path, "ruby/hello-world"), file.path(ex_path, "r/hello-world"))
file_list <- c("~/hello-world.R", file.path(ex_path, "ruby/hello-world/hello-world.rb"), file.path(ex_path, "r/hello-world/leap.py"))

# Create files for testing
lapply(dir_list, dir.create, recursive = TRUE)
lapply(file_list, file.create)

test_that("Filepath does not exist", {
  expect_error(iteration("~/imaginary"))
  expect_error(iteration("~/hello-world.R"))
})

test_that("Filepath specifies a directory", {
  expect_error(iteration(ex_path))
})

test_that("Filepath does not match the exercism path.", {
  expect_error(iteration("~/hello-world.R"))
})

test_that("language track is not supported", {
  expect_error(iteration(file.path(get_exercism_path(), "ruby/bob/bob.rb")))
})

test_that("File extension does not match the language identifier", {
  expect_error(iteration(file.path(get_exercism_path(), "r/leap/leap.py")))
})
