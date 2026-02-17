test_that("Checking show_fibmatrix ggplot class", {
  result <- show_fibmatrix(fibdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_fibmatrix reactable class", {
  result <- show_fibmatrix(fibdata, asreact = T)
  expect_is(result, 'reactable')
})
test_that("Checking show_fibmatrix plotly class", {
  result <- show_fibmatrix(fibdata, plotly = T)
  expect_is(result, 'plotly')
})

# Test wet/dry subsetting
test_that("show_fibmatrix errors if wetdry info is not provided", {
  expect_error(show_fibmatrix(enterodata,
                              lagyr = 1, subset_wetdry = "dry", temporal_window = 2),
               regexp = 'temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples')
})
