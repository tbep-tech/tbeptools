test_that("Checking show_tdlcrkindiccdf class", {
  cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrkindiccdf(197, cntdat, thrsel = TRUE)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindiccdf empty data", {
  cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrkindiccdf('xxxxxxx', cntdat, thrsel = TRUE)
  expect_null(result)
})


