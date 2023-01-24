test_that("Checking show_sedimentmap class", {
  result <- show_sedimentmap(sedimentdata, param = 'Arsenic', yrrng = 2021)
  expect_is(result, 'leaflet')
})

test_that("Checking show_sedimentmap class, no TEL/PEL", {
  result <- expect_warning(show_sedimentmap(sedimentdata, param = 'Selenium', yrrng = 2021))
  expect_is(result, 'leaflet')
})

test_that("Checking show_sedimentmap sanity checks", {

  expect_error(show_sedimentmap(sedimentdata, param = 'Arsenic', yrrng = c(1990, 2030)))
  expect_error(show_sedimentmap(sedimentdata, param = 'Arsenic', yrrng = c(2001, 1994)))
  expect_error(show_sedimentmap(sedimentdata, param = 'asdf', yrrng = c(1993, 2000)))

})
