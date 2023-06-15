# Test case 1: Check if the output has the expected columns
test_that("Output has the expected columns for anlz_fibcat", {

  result <- anlz_fibcat(fibdata)
  expected_columns <- c("area", "epchc_station", "class", "yr", "mo",
                        "Latitude", "Longitude", "ecoli", "ecocci", "ind",
                        "cat", "col")
  expect_equal(colnames(result), expected_columns)

})

# Test case 2: Check if filtering by year works correctly
test_that("Filtering by year works correctly for anlz_fibcat", {

  result <- anlz_fibcat(fibdata, yrsel = 2020)
  expected_years <- c(2020)
  expect_equal(unique(result$yr), expected_years)

})

# Test case 3: Check if filtering by month works correctly
test_that("Filtering by month works correctly for anlz_fibcat", {

  result <- anlz_fibcat(fibdata, mosel = 7)
  expected_months <- c(7)
  expect_equal(unique(result$mo), expected_months)

})

# Test case 4: Check if filtering by area works correctly
test_that("Filtering by area works correctly for anlz_fibcat", {

  result <- anlz_fibcat(fibdata, areasel = "Alafia")
  expected_areas <- c('Hillsborough River', 'Hillsborough River Tributary',  'Lake Thonotosassa',
                      'Lake Thonotosassa Tributary', 'Lake Roberta')
  expect_false(any(result$area %in% expected_areas))

})
