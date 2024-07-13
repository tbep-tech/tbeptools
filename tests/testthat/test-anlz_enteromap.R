# These tests are copied and lightly modified from test-anlz_fibmap.R

# Test case 1: Check if the output has the expected columns
test_that("Output has the expected columns for anlz_enteromap", {

  result <- anlz_enteromap(enterodata)
  expected_columns <- c("station", "yr", "mo",
                        "Latitude", "Longitude", "ecocci",
                        "cat", "col", "ind", "indnm", "conc")
  expect_equal(colnames(result), expected_columns)

})

# Test case 2: Check if filtering by year works correctly
test_that("Filtering by year works correctly for anlz_enteromap", {

  result <- anlz_enteromap(enterodata, yrsel = 2020)
  expected_years <- c(2020)
  expect_equal(unique(result$yr), expected_years)

})

# Test case 3: Check if filtering by month works correctly
test_that("Filtering by month works correctly for anlz_enteromap", {

  result <- anlz_enteromap(enterodata, mosel = 7)
  expected_months <- c(7)
  expect_equal(unique(result$mo), expected_months)

})

# Test case 4: Check error no data
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



