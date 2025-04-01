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

  df2 <- df
  df2$value <- as.character(df2$value)
  df3 <- df
  df3$period <- as.character(df3$period)
  df4 <- df
  df4$period <- factor(rep(c("wrong", "after"), each = 5), levels = c("wrong", "after"))

  expect_error(show_splitbarplot("not_a_dataframe", "period", "year", "value"),
               regexp = "df must be a data frame")
  expect_error(show_splitbarplot(df, "wrong_col", "year", "value"),
               regexp = "Specified columns not found in data frame")
  expect_error(show_splitbarplot(df, "period", "year", "non_existent_col"),
               regexp = "Specified columns not found in data frame")
  expect_error(show_splitbarplot(df, "period", "year", "value", interactive = "not_logical"),
               regexp = "interactive and exploded must be logical values")
  expect_error(show_splitbarplot(df2, "period", "year", "value"),
               regexp = "Year and value columns must be numeric")
  expect_error(show_splitbarplot(df3, "period", "year", "value"),
               regexp = "The period column must be factor")
  expect_error(show_splitbarplot(df, "period", "year", "value", value_round = -2),
               regexp = "value_round must be a non-negative number")
  expect_error(show_splitbarplot(df4, "period", "year", "value"),
               regexp = "period_col must contain only 'before' and 'after'")
  expect_error(show_splitbarplot(df, "period", "year", "value", label_points = 'wrong'),
               regexp = "label_points must be NULL or contain only 'min', 'max', or 'median'")

})

test_that("show_splitbarplot applies custom color and label settings", {
  df <- data.frame(
    period = factor(rep(c("before", "after"), each = 5), levels = c("before", "after"), ordered = TRUE),
    year = rep(2000:2004, 2),
    value = c(10, 15, 12, 14, 13, 18, 22, 20, 21, 19)
  )

  p <- show_splitbarplot(df, "period", "year", "value", bars_fill = c("blue", "red"), value_round = 1, interactive = FALSE, exploded = T)
  expect_s3_class(p, "ggplot")
})
