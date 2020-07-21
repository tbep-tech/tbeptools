test_that("Checking read_trnjsn class", {

  result <- read_trnjsn(training = TRUE)

  expect_is(result, 'data.frame')

})
