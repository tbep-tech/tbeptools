test_that("Checking show_segmatrix ggplot class", {
  result <- show_segmatrix(epcdata)
  expect_is(result, 'ggplot')
})
