test_that("Checking show_wqmatrix ggplot class", {
  result <- show_wqmatrix(epcdata, abbrev = TRUE)
  expect_is(result, 'ggplot')
})
test_that("Checking show_wqmatrix reactable class", {
  result <- show_wqmatrix(epcdata, asreact = TRUE, abbrev = TRUE)
  expect_is(result, 'reactable')
})
test_that("Checking show_wqmatrix plotly class", {
  result <- show_wqmatrix(epcdata, plotly = T)
  expect_is(result, 'plotly')
})
