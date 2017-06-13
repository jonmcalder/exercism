context("API methods")

set_api_key("test123")

test_that("check_next_problem", {
  expect_message(check_next_problem("python"))
  expect_error(check_next_problem("unknown"))
})

test_that("fetch_problem", {
  expect_error(fetch_problem(trackID = "unknown", slug = "hello-world"))
  expect_message(fetch_problem(trackID = "haskell", slug = "hello-world", force = TRUE))
  expect_warning(fetch_problem(trackID = "haskell", slug = "hello-world", force = TRUE))
  expect_error(fetch_problem(trackID = "haskell", slug = "hello-world"))
})

test_that("fetch", {
  expect_error(fetch(trackID = "unknown"))
  expect_message(fetch(trackID = "haskell", force = TRUE))
  expect_warning(fetch(trackID = "haskell", force = TRUE))
})
