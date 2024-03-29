test_that("Checking read_importfim", {
  csv <- 'fimraw.csv'

  # load and assign to object
  fimdata <- read_importfim(csv)

  # check if number of columns is correct
  result <- ncol(fimdata)
  expect_equal(result, 19)

})

test_that("Checking read_importfim, sf object", {
  csv <- 'fimraw.csv'

  # load and assign to object
  fimdata <- read_importfim(csv, locs = T)

  # check if number of columns is correct
  result <- ncol(fimdata)
  expect_equal(result, 3)

})
