test_that("Checking show_tdlcrkindic class", {
  result <- show_tdlcrkindic(479, cntdat, thrsel = TRUE, yr = 2021)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindic empty data", {
  result <- show_tdlcrkindic('xxxxxxx', cntdat, thrsel = TRUE, yr = 2021)
  expect_null(result)
})


