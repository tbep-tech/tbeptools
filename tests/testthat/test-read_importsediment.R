test_that("Checking read_importsediment class", {
  path <- tempfile(fileext = '.zip')
  dat <- read_importsediment(path, download_latest = TRUE, remove = TRUE)
  expect_is(dat, 'tbl_df')
})
test_that("Checking read_importsediment, require zip extension", {
  expect_error(read_importsediment('aaaa'))
})
test_that("Checking read_importsediment, require download if path doesn't exist", {
  expect_error(read_importsediment('aaa.zip', download_latest = FALSE))
})
