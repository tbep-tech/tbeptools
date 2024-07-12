test_that("show_enteromap correctly creates a leaflet map", {

  # Test if the function runs without errors
  result <- show_enteromap(enterodata, yrsel = 2020, mosel = 7)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})
