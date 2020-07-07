test_that("Checking show_segmatrix ggplot class", {
  result <- show_segmatrix(epcdata)
  expect_is(result, 'ggplot')
})

test_that("Checking show_segmatrix plotly class", {
  result <- show_segmatrix(epcdata, plotly = T)
  expect_is(result, 'plotly')
})
