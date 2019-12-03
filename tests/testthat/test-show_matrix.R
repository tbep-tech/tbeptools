test_that("Checking show_matrix ggplot class", {
  result <- show_matrix(epcdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_matrix reactable class", {
  result <- show_matrix(epcdata, asreact = TRUE)
  expect_is(result, 'reactable')
})
