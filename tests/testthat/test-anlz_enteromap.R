# These tests are copied and lightly modified from test-anlz_fibmap.R

# Check if the output has the expected columns
test_that("Output has the expected columns for anlz_enteromap", {

  result <- anlz_enteromap(enterodata)
  expected_columns <- c("station", "long_name", "yr", "mo",
                        "Latitude", "Longitude", "ecocci",
                        "cat", "col", "ind", "indnm", "conc")
  expect_equal(colnames(result), expected_columns)

})

# Check if filtering by year works correctly
test_that("Filtering by year works correctly for anlz_enteromap", {

  result <- anlz_enteromap(enterodata, yrsel = 2020)
  expected_years <- c(2020)
  expect_equal(unique(result$yr), expected_years)

})

# Check if filtering by month works correctly
test_that("Filtering by month works correctly for anlz_enteromap", {

  result <- anlz_enteromap(enterodata, mosel = 7)
  expected_months <- c(7)
  expect_equal(unique(result$mo), expected_months)

})

# Check if filtering by area works correctly
test_that("Filtering by area works correctly for anlz_enteromap", {

  result <- anlz_enteromap(enterodata, areasel = 'Old Tampa Bay', mosel = 7)
  expected_area <- 'Old Tampa Bay'
  expect_equal(unique(result$long_name), expected_area)

})

# Check error no data
test_that("Checking error for no data with anlz_enteromap", {

  expect_error(anlz_enteromap(enterodata, yrsel = 1900, mosel = 5))

})


# Test wet/dry subsetting
test_that("anlz_enteromap errors if wetdry info is not provided", {
  expect_error(anlz_enteromap(enterodata, wetdry = TRUE, temporal_window = 2),
               regxp = 'temporal_window and wet_threshold must both be provided in order to in order to differentiate wet vs. dry samples')
})

test_that("FALSE default for wetdry works", {

  result_a <- anlz_enteromap(enterodata)
  result_b <- anlz_enteromap(enterodata, wetdry = FALSE)

  expect_equivalent(result_a, result_b)

})

test_that("wet/dry subsetting does lead to different data frames", {

  result_a <- anlz_enteromap(enterodata)
  result_b <- anlz_enteromap(enterodata, wetdry = TRUE, temporal_window = 2, wet_threshold = 0.5)

  expect_failure(expect_equivalent(result_a, result_b))
})

test_that("Checking sf outoput", {

  result <- anlz_enteromap(enterodata, assf = TRUE)

  expect_s3_class(result, "sf")
  expect_equal(ncol(result), 16)

})


