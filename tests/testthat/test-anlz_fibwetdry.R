# Mock data for fibdata and precipdata
fibdata <- data.frame(
  station = rep(c("Station1", "Station2"), each = 3),
  date = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03", "2024-01-01", "2024-01-02", "2024-01-03")),
  fib_value = runif(6, 0, 100)
)

precipdata <- data.frame(
  station = rep(c("Station1", "Station2"), each = 3),
  date = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03", "2024-01-01", "2024-01-02", "2024-01-03")),
  rain = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
)

# Test 1: correct columns in data frame
test_that("anlz_fibwetdry returns correct structure", {
  result <- anlz_fibwetdry(fibdata, precipdata)
  expect_true(all(c("station", "date", "fib_value", "rain_sampleDay", "rain_total", "wet_sample") %in% names(result)))
})

# Test(s) 2: calculate temporal windows correctly
test_that("anlz_fibwetdry calculates rain total correctly for temporal window 1", {
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 1)
  expect_equal(result$rain_total, result$rain_sampleDay)
})

test_that("anlz_fibwetdry calculates rain total correctly for temporal window 2", {
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 2, wet_threshold = 0.5)
  expected_rain_total <- c(NA, 0.3, 0.5, NA, 0.9, 1.1) # Rain total with temporal window of 2 (sum of current and previous day)
  expect_equal(result$rain_total, expected_rain_total)
})

test_that("anlz_fibwetdry calculates rain total correctly for temporal window 3", {
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 3, wet_threshold = 0.5)
  expected_rain_total <- c(NA, NA, 0.6, NA, NA, 1.5) # Rain total with temporal window of 3 (sum of current and previous two days)
  expect_equal(result$rain_total, expected_rain_total)
})


# Tests 3: calculate wet threshold correctly
test_that("anlz_fibwetdry applies wet threshold correctly", {
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 2, wet_threshold = 0.5)
  expected_wet_sample <- result$rain_total >= 0.5
  expect_equal(result$wet_sample, expected_wet_sample)
})


# Test 4
test_that("anlz_fibwetdry handles edge cases with different temporal windows", {
  # Edge case: temporal window = 1
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 1)
  expect_equal(result$rain_total, result$rain_sampleDay)

  # Edge case: temporal window > length of data
  result <- anlz_fibwetdry(fibdata, precipdata, temporal_window = 10)
  expect_true(all(is.na(result$rain_total)))
})


