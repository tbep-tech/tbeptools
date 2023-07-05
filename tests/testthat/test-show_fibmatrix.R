test_that("Checking show_fibmatrix ggplot class", {
  result <- show_fibmatrix(fibdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_fibmatrix reactable class", {
  result <- show_fibmatrix(fibdata, asreact = T)
  expect_is(result, 'reactable')
})
test_that("Checking show_fibmatrix plotly class", {
  result <- show_fibmatrix(fibdata, plotly = T)
  expect_is(result, 'plotly')
})
