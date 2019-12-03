test_that("Checking read_importwq", {
  xlsx <- here::here('vignettes/2018_Results_Updated.xls')

  # load and assign to object
  epcdata <- read_importwq(xlsx)

  # check if number of columns is equal to 11
  result <- ncol(epcdata)
  expect_equal(result, 11)

})
