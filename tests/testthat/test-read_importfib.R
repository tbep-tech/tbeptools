test_that("Checking read_importfib", {
  xlsx <- 'exdatatmp.xlsx'

  # load and assign to object
  fibdata <- read_importfib(xlsx, all = F)

  # check if number of columns is equal to 18
  result <- ncol(fibdata)
  expect_equal(result, 18)

  # check area values, note Lake Roberta is not in xlsx
  result <- sort(unique(fibdata$area))
  expect_equal(result, c("Alafia River", "Alafia River Tributary", "Hillsborough River",
                         "Hillsborough River Tributary", "Lake Thonotosassa", "Lake Thonotosassa Tributary"
  ))

})

test_that("Checking read_importfib all parameters", {
  xlsx <- 'exdatatmp.xlsx'

  # load and assign to object
  fibdata <- read_importfib(xlsx, all = T)

  # check if number of columns is equal to 152
  result <- sort(unique(fibdata$area))
  expect_equal(result, c("Alafia River", "Alafia River Tributary", "Big Bend", "Hillsborough Bay",
                         "Hillsborough Bay Tributary", "Hillsborough River", "Hillsborough River Tributary",
                         "Lake Thonotosassa", "Lake Thonotosassa Tributary", "Little Manatee River",
                         "Lower Tampa Bay", "McKay Bay", "Middle Tampa Bay", "Old Tampa Bay",
                         "Old Tampa Bay Tributary", "Palm River"))

})
