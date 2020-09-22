test_that("Checking read_transect class", {

  result <- read_transect(training = TRUE)

  expect_is(result, 'data.frame')

})
