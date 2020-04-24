test_that("Checking read_formfim", {
  csv <- 'fimraw.csv'

  # load
  rawdat <- read.csv(csv, stringsAsFactors = F)

  # format
  frmdat <- read_formfim(rawdat)

  # check if number of columns is correct
  result <- ncol(frmdat)
  expect_equal(result, 17)

})
