test_that("run_fvfm() checks its arguments before starting Python", {
  expect_error(run_fvfm(file.path(tempdir(), "no-such-folder")))
  expect_error(run_fvfm(fvfm_example("example1.pim")), "must be a folder")

  out <- tempfile(fileext = ".csv")
  file.create(out)
  expect_error(run_fvfm(fvfm_example(), output = out), "already exists")
  expect_error(run_fvfm(output = out), "already exists")
})

test_that("run_fvfm() without a directory cleans up its empty folder", {
  out <- tempfile(fileext = ".csv")
  file.create(out)
  before <- list.files(tempdir(), pattern = "^fvfm_no_folder_")
  expect_error(run_fvfm(output = out), "already exists")
  expect_setequal(list.files(tempdir(), pattern = "^fvfm_no_folder_"), before)
})

test_that("fvfmPy can be imported by the configured Python", {
  skip_on_cran()
  python <- tryCatch(fvfmR:::.fvfm_python(), error = function(e) NULL)
  skip_if(is.null(python), "No Python environment with fvfmPy configured")
  expect_true(fvfmR:::.check_fvfmpy(python))
})
