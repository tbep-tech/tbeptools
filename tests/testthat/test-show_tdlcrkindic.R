test_that("Checking show_tdlcrkindic class", {
  cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrkindic(197, cntdat, thrsel = TRUE)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindic empty data", {
  cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrkindic('xxxxxxx', cntdat, thrsel = TRUE)
  expect_null(result)
})


