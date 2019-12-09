test_that("Checking show_tdlcrk class", {
  dat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
  result <- show_tdlcrk(dat)
  expect_is(result, 'leaflet')
})
