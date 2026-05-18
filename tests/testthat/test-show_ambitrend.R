test_that("show_ambitrend returns a ggplot for standard AMBI input", {

  result <- show_ambitrend(ambiscr)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend returns a ggplot for AMBI-TB input", {

  result <- show_ambitrend(ambiscr_tb)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend returns a ggplot with both inputs", {

  result <- show_ambitrend(ambiscr, ambiscr_tb)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend returns a plotly object when plotly = TRUE", {

  result <- show_ambitrend(ambiscr, plotly = TRUE)
  expect_s3_class(result, 'plotly')

})

test_that("show_ambitrend yscl = FALSE runs without error", {

  result <- show_ambitrend(ambiscr, yscl = FALSE)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend bay_segment filter to a single segment runs without error", {

  result <- show_ambitrend(ambiscr, bay_segment = 'OTB')
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend bay_segment = All uses all segments", {

  result_all  <- show_ambitrend(ambiscr, bay_segment = 'All')
  result_multi <- show_ambitrend(ambiscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'))
  dat_all   <- ggplot2::ggplot_build(result_all)$data[[6]]
  dat_multi <- ggplot2::ggplot_build(result_multi)$data[[6]]
  expect_equal(dat_all, dat_multi)

})

test_that("show_ambitrend yrrng filters to the requested year range", {

  result <- show_ambitrend(ambiscr, yrrng = c(2010, 2015))
  dat <- ggplot2::ggplot_build(result)$data[[6]]
  expect_true(all(dat$x >= 2010 & dat$x <= 2015))

})

test_that("show_ambitrend accepts a single yrrng value", {

  result <- show_ambitrend(ambiscr, yrrng = 2010)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambitrend errors on invalid yrrng", {

  expect_error(show_ambitrend(ambiscr, yrrng = c(2015, 2010)))

})

test_that("show_ambitrend errors when input lacks AMBI or TBAMBI column", {

  expect_error(show_ambitrend(data.frame(x = 1)))

})
