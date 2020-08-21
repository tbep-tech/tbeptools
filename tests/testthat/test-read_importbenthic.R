test_that("Checking read_importbenthic, file does not exist error", {
  expect_error(read_importbenthic('aaaa'))
})
test_that("Checking read_importbenthic, download with mdb error", {
  expect_error(read_importbenthic('aaa', download_latest = TRUE))
})
