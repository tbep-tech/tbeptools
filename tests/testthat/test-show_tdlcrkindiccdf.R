test_that("Checking show_tdlcrkindiccdf class", {
  result <- show_tdlcrkindiccdf(1, cntdat, thrsel = TRUE, yr = 2021)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindiccdf empty data", {
  result <- show_tdlcrkindiccdf('xxxxxxx', cntdat, thrsel = TRUE, yr = 2021)
  expect_null(result)
})


