test_that("fvfm_example() returns the folder of example images", {
  dir <- fvfm_example()
  expect_true(dir.exists(dir))
  expect_setequal(list.files(dir), c("example1.pim", "example2.pim"))
})

test_that("fvfm_example() returns the path to a named file", {
  path <- fvfm_example("example1.pim")
  expect_true(file.exists(path))
  expect_equal(basename(path), "example1.pim")
})

test_that("fvfm_example() errors on an unknown file", {
  expect_error(fvfm_example("nope.pim"), "not an example file")
})
