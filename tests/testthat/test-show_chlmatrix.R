test_that("Checking show_chlmatrix ggplot class", {
  result <- show_chlmatrix(epcdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_chlmatrix reactable class", {
  result <- show_chlmatrix(epcdata, asreact = TRUE)
  expect_is(result, 'reactable')
})

