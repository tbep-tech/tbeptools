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

test_that("Checking read_importfim, sf object", {
  csv <- 'fimraw.csv'

  # load
  rawdat <- read.csv(csv, stringsAsFactors = F)

  # load and assign to object
  fimdata <- read_formfim(rawdat, locs = T)

  # check if number of columns is correct
  result <- ncol(fimdata)
  expect_equal(result, 3)

})
