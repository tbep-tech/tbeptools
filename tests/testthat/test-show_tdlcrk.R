test_that("Checking show_tdlcrk class", {
  result <- show_tdlcrk(tdldat)
  expect_is(result, 'leaflet')
})
