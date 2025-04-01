# Sample hurricane dataset
hurricanes <- data.frame(
  date_beg = as.Date(c(
    "1980-07-31", "1980-09-04", "1980-11-07",
    "1981-05-06", "1981-08-07", "1981-11-12")),
  scale = c(6, 1, 3, 1, 2, 1)
)

# Define a split date
split_date <- as.Date("1981-07-01")

# Expected output for default stats (sum, average, count)
expected_output <- tibble(
  year = c(1981, 1982),
  period = factor(c("before", "after"), levels = c("before", "after"), ordered = TRUE),
  sum = c(11, 3),
  avg = c(2.75, 1.5),
  n = c(4, 2)
)

# Test default statistics
expect_equal(anlz_splitstorms(hurricanes, split_date), expected_output)

# Test with custom statistics, includes unnamed
custom_stats <- list(max = max, min = min)
expected_output <- tibble(
  year = c(1981, 1982),
  period = factor(c("before", "after"), levels = c("before", "after"), ordered = TRUE),
  max = c(6, 2),
  min = c(1, 1)
)
expect_equal(anlz_splitstorms(hurricanes, split_date, stats = custom_stats), expected_output)

# Test empty dataframe input
result <- anlz_splitstorms(data.frame(date_beg = as.Date(character()), scale = numeric()), split_date)
expected <- structure(
  list(
    year = list(),
    period = structure(integer(0), levels = c("before", "after"), class = c("ordered", "factor")),
    sum = numeric(0),
    avg = numeric(0),
    n = integer(0)
  ), class = c("tbl_df", "tbl", "data.frame"), row.names = integer(0))
expect_equal(result, expected)

# Test single-row dataframe
single_row_df <- data.frame(date_beg = as.Date("1980-07-31"), scale = 6)
expected_single_output <- tibble(
  year = 1981,
  period = factor("before", levels = c("before", "after"), ordered = TRUE),
  sum = 6,
  avg = 6,
  n = 1
)
expect_equal(anlz_splitstorms(single_row_df, split_date), expected_single_output)
