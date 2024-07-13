test_that("show_enteromap correctly creates a leaflet map", {

  # Test if the function runs without errors
  result <- show_enteromap(enterodata, yrsel = 2020, mosel = 7)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})


test_that("show_enteromap errors if wetdry info is not provided", {
  expect_error(show_enteromap(enterodata, wetdry = TRUE, temporal_window = 2),
               regxp = 'temporal_window and wet_threshold must both be provided in order to differentiate wet vs. dry samples')
})
