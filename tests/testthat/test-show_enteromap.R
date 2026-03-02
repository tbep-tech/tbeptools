test_that("show_enteromap correctly creates a leaflet map", {

  # Test if the function runs without errors
  result <- show_enteromap(enterodata, yrsel = 2020, mosel = 7, addsta = T)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})

test_that("show_enteromap errors if wetdry info is not provided", {
  expect_error(show_enteromap(enterodata, wetdry = TRUE, temporal_window = 2),
               regexp = 'temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples')
})

test_that("show_enteromap works for wetdry", {

  result <- show_enteromap(enterodata, yrsel = 2010, mosel = 7, wetdry = TRUE, temporal_window = 2, wet_threshold = 0.5)

  # check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})

