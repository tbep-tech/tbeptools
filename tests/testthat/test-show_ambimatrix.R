test_that("show_ambimatrix returns a ggplot for standard AMBI input", {

  result <- show_ambimatrix(ambiscr)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambimatrix returns a ggplot for AMBI-TB input", {

  result <- show_ambimatrix(ambiscr_tb)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambimatrix returns a plotly object when plotly = TRUE", {

  result <- show_ambimatrix(ambiscr, plotly = TRUE)
  expect_s3_class(result, 'plotly')

})

test_that("show_ambimatrix window = FALSE runs without error", {

  result <- show_ambimatrix(ambiscr, window = FALSE)
  expect_s3_class(result, 'ggplot')

})

test_that("show_ambimatrix errors on invalid yrrng", {

  expect_error(show_ambimatrix(ambiscr, yrrng = 1998))
  expect_error(show_ambimatrix(ambiscr, yrrng = c(2009, 1997)))

})
