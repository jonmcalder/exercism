context("Utils")

current_key <- try(get_api_key(), TRUE)
current_path <- try(get_exercism_path(), TRUE)

on.exit({
  if (class(current_key) != "try-error") {
    set_api_key(current_key)
  }
  if (class(current_path) != "try-error") {
    set_exercism_path(current_path)
  }
})

api_test_key <- "thisisanapitestkeythatislength32"

test_that("set and get API key methods", {
  expect_warning(set_api_key("invalidapitestkey", force = TRUE))
  expect_message(set_api_key(api_test_key, force = TRUE), "EXERCISM_KEY")
  expect_error(set_api_key(api_test_key))
  expect_equal(get_api_key(), api_test_key)
})

test_that("set and get path methods", {
  expect_message(set_exercism_path("exercism", force = TRUE), "EXERCISM_PATH")
  expect_equal(get_exercism_path(), "exercism")
  expect_error(set_exercism_path("exercism"))
  expect_message(set_exercism_path(force = TRUE), "EXERCISM_PATH")
})

test_that("check API response method", {
  expect_silent(check_api_response(httr::GET("http://httpbin.org/ip")))
  expect_warning(check_api_response(httr::GET("http://httpbin.org/xml")))
  expect_error(check_api_response(httr::GET("http://httpbin.org/wrong")))
})

if (requireNamespace("lintr", quietly = TRUE)) {
  context("Lints")
  test_that("Package Style", {
    lintr::expect_lint_free()
  })
}
