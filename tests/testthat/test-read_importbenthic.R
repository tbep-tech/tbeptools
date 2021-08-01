test_that("Checking read_importbenthic class", {
  path <- tempfile(fileext = '.zip')
  dat <- read_importbenthic(path, download_latest = TRUE, remove = TRUE)
  expect_is(dat, 'tbl_df')
})
test_that("Checking read_importbenthic, require zip extension", {
  expect_error(read_importbenthic('aaaa'))
})
test_that("Checking read_importbenthic, require download if path doesn't exist", {
  expect_error(read_importbenthic('aaa.zip', download_latest = FALSE))
})
