test_that("Testing output class for show_matrixpotly", {
  mat <- show_wqmatrix(epcdata)
  result <- show_matrixplotly(mat)
  expect_is(result, 'plotly')
})
