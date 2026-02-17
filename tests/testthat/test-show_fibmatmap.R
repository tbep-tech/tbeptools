test_that("show_fibmatmap returns a leaflet map for non-EPCHC, non-manco", {
  map <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), addsta = T))
  expect_s3_class(map, "leaflet")
})

test_that("show_fibmatmap returns list of data used if listout is TRUE", {
  dat <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'),
                                       listout = T))
  expect_equal(class(dat), "list")
  expect_equal(names(dat), c('icons', 'tomapsta', 'tomapseg', 'bayseg'))
})

test_that("show_fibmatmap returns a leaflet map for EPCHC", {
  map <- show_fibmatmap(fibdata, yrsel = 2020, areasel = c('Hillsborough River'))
  expect_s3_class(map, "leaflet")
})

test_that("show_fibmatmap returns a leaflet map for Manatee County", {
  map <- show_fibmatmap(mancofibdata, yrsel = 2020, areasel = c('Manatee River'))
  expect_s3_class(map, "leaflet")
})

test_that("show_fibmatmap errors on invalid areasel for EPCHC data", {
  expect_error(
    show_fibmatmap(fibdata, yrsel = 2020, areasel = "Invalid Area"),
    regexp = "Invalid value\\(s\\) for areasel: Invalid Area"
  )
})

test_that("show_fibmatmap errors on invalid areasel for Manatee County data", {
  expect_error(
    show_fibmatmap(mancofibdata, yrsel = 2020, areasel = "Invalid Area"),
    regexp = "Invalid value\\(s\\) for areasel: Invalid Area"
  )
})

test_that("show_fibmatmap subsets data for wet or dry samples", {
  map_wet <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), subset_wetdry = "wet", temporal_window = 2, wet_threshold = 0.3))
  map_dry <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), subset_wetdry = "dry", temporal_window = 2, wet_threshold = 0.3))
  expect_s3_class(map_wet, "leaflet")
  expect_s3_class(map_dry, "leaflet")
})

test_that("show_fibmatmap errors for wet or dry samples with EPCHC data", {
  expect_error(
    show_fibmatmap(fibdata, yrsel = 2020, areasel = "Hillsborough River",
                   subset_wetdry = "wet", temporal_window = 7, wet_threshold = 2),
    regexp = "Subset to wet or dry samples not supported for epchc data"
  )
})

test_that("show_fibmatmap errors for wet or dry samples with Manatee County data", {
  expect_error(
    show_fibmatmap(mancofibdata, yrsel = 2020, areasel = "Manatee River",
                   subset_wetdry = "wet", temporal_window = 7, wet_threshold = 2),
    regexp = "Subset to wet or dry samples not supported for County data"
  )
})
test_that("show_fibmatmap includes bay segment polygons", {
  map <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB')))
  expect_s3_class(map, "leaflet")
  expect_true(length(map$x$calls) > 1)  # Checking multiple leaflet layers added
})

test_that("Check error if insufficient data for lag yr", {

  expect_error(show_fibmatmap(mancofibdata, yrsel = 2019, areasel = 'Manatee River', warn = F),
    regexp = "Insufficient data for lagyr"
  )

})
