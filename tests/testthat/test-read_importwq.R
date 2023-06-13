test_that("Checking read_importwq", {
  xlsx <- 'exdatatmp.xlsx'

  # load and assign to object
  epcdata <- read_importwq(xlsx)

  # check if number of columns is equal to 26
  result <- ncol(epcdata)
  expect_equal(result, 26)

  # check secchi sd_q
  result <- unique(epcdata$sd_q)
  expect_equal(result, c(NA, ">"))

})

test_that("Checking read_importwq all parameters", {
  xlsx <- 'exdatatmp.xlsx'

  # load and assign to object
  epcdata <- read_importwq(xlsx, all = T)

  # check if number of columns is equal to 152
  result <- ncol(epcdata)
  expect_equal(result, 152)

})
