test_that("Checking show_sedimentpelmap class", {
  result <- show_sedimentpelmap(sedimentdata, yrrng = 2022)
  expect_is(result, 'leaflet')
})
