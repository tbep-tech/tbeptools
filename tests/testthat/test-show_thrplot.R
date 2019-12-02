test_that("Checking show_thrplot class", {
  result <- show_thrplot(epcdata)
  expect_is(result, 'ggplot')
})
