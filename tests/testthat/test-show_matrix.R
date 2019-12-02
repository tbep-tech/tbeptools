test_that("Checking show_matrix", {
  result <- show_matrix(epcdata)
  expect_is(result, 'ggplot')
})
