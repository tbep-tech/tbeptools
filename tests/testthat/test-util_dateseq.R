test_that("Full year span works correctly", {
  result <- util_dateseq("2024-01-01", "2024-12-31")

  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
  expect_equal(names(result), c("start", "end"))
  expect_equal(nrow(result), 12)  # 12 months = 12 pairs

  # Check first and last pairs
  expect_equal(result$start[1], as.Date("2024-01-01"))
  expect_equal(result$end[1], as.Date("2024-01-31"))
  expect_equal(result$start[12], as.Date("2024-12-01"))
  expect_equal(result$end[12], as.Date("2024-12-31"))
})

test_that("Mid-month start and end works correctly", {
  result <- util_dateseq("2024-01-15", "2024-12-15")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 12)

  # Check that start date and end of first month are included
  expect_equal(result$start[1], as.Date("2024-01-15"))
  expect_equal(result$end[1], as.Date("2024-01-31"))

  # Check final pair
  expect_equal(result$start[12], as.Date("2024-12-01"))
  expect_equal(result$end[12], as.Date("2024-12-15"))
})

test_that("Same month returns duplicated dates", {
  result <- util_dateseq("2024-03-10", "2024-03-25")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)

  # Both dates should be duplicated
  expect_equal(result$start[1], as.Date("2024-03-10"))
  expect_equal(result$end[1], as.Date("2024-03-25"))
})

test_that("Spanning few months works correctly", {
  result <- util_dateseq("2024-02-15", "2024-05-20")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 4)  # Feb, Mar, Apr, May = 4 pairs

  # Check key dates
  expect_equal(result$start[1], as.Date("2024-02-15"))
  expect_equal(result$end[1], as.Date("2024-02-29"))
  expect_equal(result$start[4], as.Date("2024-05-01"))
  expect_equal(result$end[4], as.Date("2024-05-20"))
})

test_that("Cross-year span works correctly", {
  result <- util_dateseq("2023-11-10", "2024-02-20")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 4)  # Nov 2023, Dec 2023, Jan 2024, Feb 2024

  # Check year transition
  expect_equal(result$start[1], as.Date("2023-11-10"))
  expect_equal(result$end[2], as.Date("2023-12-31"))
  expect_equal(result$start[3], as.Date("2024-01-01"))
  expect_equal(result$end[4], as.Date("2024-02-20"))
})

test_that("Start date on last day of month creates duplicate", {
  result <- util_dateseq("2023-01-31", "2023-02-20")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)

  # First pair should have duplicated Jan 31
  expect_equal(result$start[1], as.Date("2023-01-31"))
  expect_equal(result$end[1], as.Date("2023-01-31"))
  expect_equal(result$start[2], as.Date("2023-02-01"))
  expect_equal(result$end[2], as.Date("2023-02-20"))
})

test_that("End date on first day of month creates duplicate", {
  result <- util_dateseq("2023-01-15", "2023-03-01")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)

  # Last pair should have duplicated Mar 1
  expect_equal(result$start[1], as.Date("2023-01-15"))
  expect_equal(result$end[1], as.Date("2023-01-31"))
  expect_equal(result$start[3], as.Date("2023-03-01"))
  expect_equal(result$end[3], as.Date("2023-03-01"))
})

test_that("All results have even number of total dates", {
  test_cases <- list(
    c("2024-01-01", "2024-12-31"),
    c("2024-01-15", "2024-12-15"),
    c("2024-03-10", "2024-03-25"),
    c("2024-02-15", "2024-05-20"),
    c("2023-11-10", "2024-02-20"),
    c("2023-01-31", "2023-02-20"),
    c("2023-01-15", "2023-03-01")
  )

  for (case in test_cases) {
    result <- util_dateseq(case[1], case[2])
    total_dates <- nrow(result) * 2  # Each row has 2 dates
    expect_equal(total_dates %% 2, 0,
                 info = paste("Case:", case[1], "to", case[2]))
  }
})

