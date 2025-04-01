test_that("anlz_splitdata correctly splits data and calculates basic statistics", {
  # Create test data spanning multiple years
  test_data <- data.frame(
    date = seq.Date(as.Date("2018-01-01"), as.Date("2022-12-31"), by = "month"),
    value = 1:60
  )

  # Test with split date in the middle (June 15, 2020)
  split_date <- as.Date("2020-06-15")
  result <- anlz_splitdata(test_data, split_date, "date", "value")

  # Check structure of result
  expect_s3_class(result, "data.frame")
  expect_named(result, c("year", "period", "avg"))

  # Check there are both "before" and "after" periods
  expect_true(all(c("before", "after") %in% result$period))

  # Check that years are assigned correctly
  expect_true(all(result$year >= 2018 & result$year <= 2023))

})
