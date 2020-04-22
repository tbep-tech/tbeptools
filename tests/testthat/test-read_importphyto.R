test_that("Checking read_importphyto", {
  xlsx <- 'phytodata.xlsx'

  # load and assign to object
  phytodata <- read_importphyto(xlsx)

  # check if number of columns is equal to 11
  result <- ncol(phytodata)
  expect_equal(result, 8)

})
