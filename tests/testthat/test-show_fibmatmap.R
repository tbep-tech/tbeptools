test_that("show_fibmatmap returns a leaflet map for non-EPCHC", {
  map <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), indic = 'entero'))
  expect_s3_class(map, "leaflet")
})

test_that("show_fibmatmap returns a leaflet map for EPCHC", {
  map <- expect_warning(show_fibmatmap(fibdata, yrsel = 2020, areasel = c('Hillsborough River'), indic = 'fcolif'))
  expect_s3_class(map, "leaflet")
})


test_that("show_fibmatmap errors on invalid areasel for EPCHC data", {
  expect_error(
    show_fibmatmap(fibdata, yrsel = 2020, areasel = "Invalid Area", indic = 'fcolif'),
    regxp = "Invalid value(s) for areasel: Invalid Area"
  )
})

# Test 5: Handles wet/dry sample subset with correct parameters
test_that("show_fibmatmap subsets data for wet or dry samples", {
  map_wet <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), indic = 'entero', subset_wetdry = "wet", temporal_window = 2, wet_threshold = 0.3))
  map_dry <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), indic = 'entero', subset_wetdry = "dry", temporal_window = 2, wet_threshold = 0.3))
  expect_s3_class(map_wet, "leaflet")
  expect_s3_class(map_dry, "leaflet")
})

test_that("show_fibmatmap errors for wet or dry samples with EPCHC data", {
  expect_error(
    show_fibmatmap(fibdata, yrsel = 2020, areasel = "Hillsborough River", indic = 'fcolif',
                   subset_wetdry = "wet", temporal_window = 7, wet_threshold = 2),
    regxp = "Subset to wet or dry samples not supported for epchc data"
  )
})

test_that("show_fibmatmap includes bay segment polygons", {
  map <- expect_warning(show_fibmatmap(enterodata, yrsel = 2020, areasel = c('OTB', 'HB'), indic = 'entero'))
  expect_s3_class(map, "leaflet")
  expect_true(length(map$x$calls) > 1)  # Checking multiple leaflet layers added
})
