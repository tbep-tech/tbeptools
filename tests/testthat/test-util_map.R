# Create a dummy sf object for the map bounds
tomap <- tibble::tibble(
  lon = -82.6365,
  lat = 27.75822
)
tomap <- sf::st_as_sf(tomap, coords = c('lon', 'lat'), crs = 4326)

test_that("util_map correctly creates a leaflet map", {
  result <- util_map(tomap)

  expect_s3_class(result, "leaflet")

  expect_true(any(vapply(
    result$x$calls,
    function(x) identical(x$method, "addProviderTiles") &&
      length(x$args) > 0 &&
      identical(as.character(x$args[[1]]), "Esri.WorldImagery"),
    logical(1)
  )))
})

test_that("util_map has no minimap when minimap argument is NULL", {

  # Test if the function runs without errors
  result <- util_map(tomap, minimap = NULL)

  # Check if the result is a leaflet object
  expect_s3_class(result, "leaflet")

})




