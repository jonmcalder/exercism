context("API methods")

exercism_path <- "~/temp"
exercism_key <- "test123"

dir.create(exercism_path)
Sys.setenv(EXERCISM_KEY = exercism_key)
Sys.setenv(EXERCISM_PATH = path.expand(exercism_path))

on.exit({
  unlink(exercism_path, recursive = TRUE, force = TRUE)
  Sys.unsetenv("EXERCISM_KEY")
  Sys.unsetenv("EXERCISM_PATH")
})

test_that("check_next_problem", {
  expect_message(check_next_problem("python"))
  expect_error(check_next_problem("unknown"))
})

test_that("fetch_next", {
  expect_error(fetch_next(track_id = "unknown", open = FALSE))
  expect_message(fetch_next(track_id = "haskell", force = TRUE, open = FALSE))
  expect_warning(fetch_next(track_id = "haskell", force = TRUE, open = FALSE),
                 "Problem folder already exists")
  expect_warning(fetch_next(track_id = "haskell", open = FALSE),
                 "Not submitted")
})

test_that("fetch_problem", {

  expect_error(fetch_problem(
    track_id = "unknown",
    slug = "hello-world",
    open = FALSE
  ))

  expect_message(fetch_problem(
    track_id = "haskell",
    slug = "anagram",
    force = TRUE,
    open = FALSE
  ))

  expect_warning(fetch_problem(
    track_id = "haskell",
    slug = "anagram",
    force = TRUE,
    open = FALSE
  ), "Problem folder already exists")

  expect_error(fetch_problem(
    track_id = "haskell",
    slug = "hello-world",
    open = FALSE
  ), "Problem folder already exists")

})
