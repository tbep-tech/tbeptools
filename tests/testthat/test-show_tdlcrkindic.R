cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
test_that("Checking show_tdlcrkindic class", {
  result <- show_tdlcrkindic(197, cntdat, thrsel = TRUE)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindic empty data", {
  result <- show_tdlcrkindic('xxxxxxx', cntdat, thrsel = TRUE)
  expect_null(result)
})


