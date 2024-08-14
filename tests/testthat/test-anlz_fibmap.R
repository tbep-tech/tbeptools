# Test case 1: Check if the output has the expected columns
test_that("Output has the expected columns for anlz_fibmap", {

  result <- anlz_fibmap(fibdata)
  expected_columns <- c("area", "epchc_station", "class", "yr", "mo",
                        "Latitude", "Longitude", "ecoli", "entero", "ind",
                        "cat", "col")
  expect_equal(colnames(result), expected_columns)

})

# Test case 2: Check if filtering by year works correctly
test_that("Filtering by year works correctly for anlz_fibmap", {

  result <- anlz_fibmap(fibdata, yrsel = 2020)
  expected_years <- c(2020)
  expect_equal(unique(result$yr), expected_years)

})

# Test case 3: Check if filtering by month works correctly
test_that("Filtering by month works correctly for anlz_fibmap", {

  result <- anlz_fibmap(fibdata, mosel = 7)
  expected_months <- c(7)
  expect_equal(unique(result$mo), expected_months)

})

# Test case 4: Check if filtering by area works correctly
test_that("Filtering by area works correctly for anlz_fibmap", {

  result <- anlz_fibmap(fibdata, areasel = "Alafia")
  expected_areas <- c('Hillsborough River', 'Hillsborough River Tributary',  'Lake Thonotosassa',
                      'Lake Thonotosassa Tributary', 'Lake Roberta')
  expect_false(any(result$area %in% expected_areas))

})

# Test case 5: Check error no data
test_that("Checking error for no data with anlz_fibmap", {

  expect_error(anlz_fibmap(fibdata, yrsel = 2020, mosel = 5, areasel = "Alafia"),
    'No FIB data for May 2020, Alafia')

})

# Test case 6: Check sf output
test_that("Checking sf outoput for anlz_fibmap", {

  result <- anlz_fibmap(fibdata, assf = TRUE)

  expect_s3_class(result, "sf")
  expect_equal(ncol(result), 17)

})

