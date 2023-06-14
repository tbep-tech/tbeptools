test_that("Checking read_importepc", {
  xlsx <- 'exdatatmp.xlsx'

  # load and assign to object
  epcall <- read_importepc(xlsx)

  # check if number of columns is equal to 162
  result <- ncol(epcall)
  expect_equal(result, 162)

})
