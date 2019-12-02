test_that("Checking show_boxplot class", {
  result <- show_boxplot(epcdata)
  expect_is(result, 'ggplot')
})
