test_that("fvfm_setup() does nothing if the user declines", {
  local_mocked_bindings(askYesNo = function(...) FALSE, .package = "utils")
  local_mocked_bindings(
    virtualenv_create  = function(...) stop("should not be called"),
    virtualenv_install = function(...) stop("should not be called"),
    .package = "reticulate"
  )
  expect_message(res <- fvfm_setup(ask = TRUE), "Setup cancelled")
  expect_null(res)
})

test_that("cancelling the prompt (NA) also does nothing", {
  local_mocked_bindings(askYesNo = function(...) NA, .package = "utils")
  local_mocked_bindings(
    virtualenv_create  = function(...) stop("should not be called"),
    virtualenv_install = function(...) stop("should not be called"),
    .package = "reticulate"
  )
  expect_message(res <- fvfm_setup(ask = TRUE), "Setup cancelled")
  expect_null(res)
})
