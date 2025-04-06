# Test the read_prism_rasters function
test_that("read_prism_rasters correctly processes PRISM raster files", {

  # directories
  dir_tif <- here::here("inst/prism")

  # Call the function with our mock directory
  result <- read_prism_rasters(dir_tif)

  # Test that the output is a data frame with the expected number of rows
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 10)

  # Test column names and types
  expect_named(result, c("path_tif", "lyr", "date", "md", "variable", "version", "date_updated"))
  expect_type(result$path_tif, "character")
  expect_type(result$lyr, "character")
  expect_s3_class(result$date, "Date")
  expect_type(result$md, "character")
  expect_type(result$variable, "character")
  expect_type(result$version, "integer")
  expect_s3_class(result$date_updated, "Date")

})
