test_that("Checking show_sedimentpelmap class", {
  result <- show_sedimentpelmap(sedimentdata, yrrng = 2021)
  expect_is(result, 'leaflet')
})
