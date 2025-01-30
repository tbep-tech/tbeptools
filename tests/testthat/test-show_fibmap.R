test_that("show_fibmap correctly creates a leaflet map", {

  # Test if the function runs without errors
  result <- show_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Alafia', addsta = T)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})

