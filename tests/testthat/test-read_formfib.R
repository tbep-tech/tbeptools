test_that("Checking read_formfib", {
  xlsx <- 'exdatatmp.xlsx'

  # load
  rawdat <- read_importepc(xlsx)

  # format
  dat <- read_formfib(rawdat)

  # check if number of columns is equal to 18
  result <- ncol(dat)
  expect_equal(result, 18)

})
