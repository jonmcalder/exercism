context("API methods")

set_api_key("test123")
set_exercism_path()

test_that("check_next_problem", {
  expect_message(check_next_problem("python"))
  expect_error(check_next_problem("unknown"))
})

test_that("fetch_problem", {

  expect_error(fetch_problem(
    rackID = "unknown",
    slug = "hello-world"
  ))

  expect_message(fetch_problem(
    track_id = "haskell",
    slug = "hello-world",
    force = TRUE
  ))

  expect_warning(fetch_problem(
    track_id = "haskell",
    slug = "hello-world",
    force = TRUE
  ))

  expect_error(fetch_problem(
    track_id = "haskell",
    slug = "hello-world"
  ))

})

test_that("fetch", {
  expect_error(fetch(track_id = "unknown"))
  expect_message(fetch(track_id = "haskell", force = TRUE))
  expect_warning(fetch(track_id = "haskell", force = TRUE))
})
