test_that("Checking show_chlmatrix", {
  result <- show_chlmatrix(epcdata)
  expect_is(result, 'ggplot')
})
