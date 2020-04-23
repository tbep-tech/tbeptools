test_that("Checking read_importfim", {
  csv <- 'fimraw.csv'

  # load and assign to object
  fimdata <- read_importfim(csv)

  # check if number of columns is equal to 11
  result <- ncol(fimdata)
  expect_equal(result, 19)

})