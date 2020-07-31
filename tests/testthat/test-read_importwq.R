test_that("Checking read_importwq", {
  xlsx <- 'exdata.xls'

  # load and assign to object
  epcdata <- read_importwq(xlsx)

  # check if number of columns is equal to 22
  result <- ncol(epcdata)
  expect_equal(result, 22)

})
