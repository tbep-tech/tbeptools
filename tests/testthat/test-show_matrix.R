test_that("Checking show_matrix ggplot class", {
  result <- show_matrix(epcdata, historic = TRUE, abbrev = TRUE, partialyr = TRUE)
  expect_is(result, 'ggplot')
})
test_that("Checking show_matrix reactable class", {
  result <- show_matrix(epcdata, asreact = TRUE, historic = TRUE, abbrev = TRUE)
  expect_is(result, 'reactable')
})
test_that("Checking show_matrix plotly class", {
  result <- show_matrix(epcdata, plotly = T)
  expect_is(result, 'plotly')
})
