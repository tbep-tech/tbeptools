test_that("show_splitbarplot returns a plot object", {
  df <- data.frame(
    period = factor(rep(c("before", "after"), each = 5), levels = c("before", "after"), ordered = TRUE),
    year = rep(2000:2004, 2),
    value = c(10, 15, 12, 14, 13, 18, 22, 20, 21, 19)
  )

  p <- show_splitbarplot(df, "period", "year", "value", interactive = FALSE)
  expect_s3_class(p, "ggplot")
})

test_that("show_splitbarplot returns an interactive plot when interactive = TRUE", {
  df <- data.frame(
    period = factor(rep(c("before", "after"), each = 5), levels = c("before", "after"), ordered = TRUE),
    year = rep(2000:2004, 2),
    value = c(10, 15, 12, 14, 13, 18, 22, 20, 21, 19)
  )

  p <- show_splitbarplot(df, "period", "year", "value", interactive = TRUE)
  expect_s3_class(p, "plotly")
})

test_that("show_splitbarplot throws an error for invalid inputs", {
  df <- data.frame(
    period = factor(rep(c("before", "after"), each = 5), levels = c("before", "after"), ordered = TRUE),
    year = rep(2000:2004, 2),
    value = c(10, 15, 12, 14, 13, 18, 22, 20, 21, 19)
  )

  expect_error(show_splitbarplot("not_a_dataframe", "period", "year", "value"))
  expect_error(show_splitbarplot(df, "wrong_col", "year", "value"))
  expect_error(show_splitbarplot(df, "period", "year", "non_existent_col"))
  expect_error(show_splitbarplot(df, "period", "year", "value", interactive = "not_logical"))
})

test_that("show_splitbarplot applies custom color and label settings", {
  df <- data.frame(
    period = factor(rep(c("before", "after"), each = 5), levels = c("before", "after"), ordered = TRUE),
    year = rep(2000:2004, 2),
    value = c(10, 15, 12, 14, 13, 18, 22, 20, 21, 19)
  )

  p <- show_splitbarplot(df, "period", "year", "value", bars_fill = c("blue", "red"), value_round = 1, interactive = FALSE)
  expect_s3_class(p, "ggplot")
})
