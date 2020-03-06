test_that("Checking show_tdlcrkindiccdf class", {
  cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrkindiccdf(197, cntdat, thrsel = TRUE)
  expect_is(result, 'plotly')
})

