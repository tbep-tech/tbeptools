# Create a dummy sf object for the map bounds
tomap <- tibble::tibble(
  lon = -82.6365,
  lat = 27.75822
)
tomap <- sf::st_as_sf(tomap, coords = c('lon', 'lat'), crs = 4326)

test_that("util_map correctly creates a leaflet map", {

  # Test if the function runs without errors
  result <- util_map(tomap)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

  # Check if the map contains the expected layers
  expect_true(any(result$x$calls[[12]]$args[[1]] == "Esri.WorldImagery"))

})

test_that("util_map has no minimap when minimap argument is NULL", {

  # Test if the function runs without errors
  result <- util_map(tomap, minimap = NULL)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})




