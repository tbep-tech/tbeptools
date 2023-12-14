test_that("Checking show_sedimentmap class", {
  result <- show_sedimentmap(sedimentdata, param = 'Arsenic', yrrng = 2022)
  expect_is(result, 'leaflet')
})

test_that("Checking show_sedimentmap class, no TEL/PEL", {
  result <- expect_warning(show_sedimentmap(sedimentdata, param = 'Selenium', yrrng = 2022))
  expect_is(result, 'leaflet')
})
