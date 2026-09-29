test_that("an explicit python path takes priority over the option", {
  py <- tempfile("python")
  file.create(py)
  old <- options(fvfmR.python = "/does/not/exist")
  on.exit(options(old), add = TRUE)
  expect_equal(fvfmR:::.fvfm_python(py), py)
})

test_that("the fvfmR.python option is used when no path is given", {
  py <- tempfile("python")
  file.create(py)
  old <- options(fvfmR.python = py)
  on.exit(options(old), add = TRUE)
  expect_equal(fvfmR:::.fvfm_python(), py)
})

test_that("a relative python path is made absolute", {
  dir <- tempfile("fvfmR")
  dir.create(dir)
  file.create(file.path(dir, "python"))
  old <- setwd(dir)
  on.exit(setwd(old), add = TRUE)
  expect_equal(fvfmR:::.fvfm_python("python"), file.path(getwd(), "python"))
})

test_that("a missing python executable gives a clear error", {
  expect_error(fvfmR:::.fvfm_python(file.path(tempdir(), "no-such-python")),
               "Python executable not found")
})
