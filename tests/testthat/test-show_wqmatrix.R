test_that("Checking show_wqmatrix ggplot class", {
  result <- show_wqmatrix(epcdata, abbrev = TRUE)
  expect_is(result, 'ggplot')
})
test_that("Checking show_wqmatrix reactable class", {
  result <- show_wqmatrix(epcdata, asreact = TRUE, abbrev = TRUE)
  expect_is(result, 'reactable')
})

