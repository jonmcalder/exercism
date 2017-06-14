context("Utils")

test_that("set and get API key methods", {
  expect_message(set_api_key("testkey123"), "EXERCISM_KEY")
  expect_equal(get_api_key(), "testkey123")
  expect_message(set_api_key("testkey12345"), "EXERCISM_KEY")
})

test_that("set and get path methods", {
  expect_message(set_exercism_path("exercism"), "EXERCISM_PATH")
  expect_equal(get_exercism_path(), "exercism")
  expect_message(set_exercism_path(), "EXERCISM_PATH")
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
