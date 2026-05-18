test_that("anlz_ambimed returns a data frame with bay_segment and yr columns", {

  result <- anlz_ambimed(ambiscr)
  expect_s3_class(result, 'data.frame')
  expect_true(all(c('bay_segment', 'yr') %in% names(result)))

})

test_that("anlz_ambimed row 1 matches expected values for standard AMBI", {

  result <- anlz_ambimed(ambiscr)[1, ]
  expect_equal(result, structure(list(
    bay_segment = structure(8L, levels = c("OTB", "HB", "MTB", "LTB", "TCB", "MR", "BCB", "All"), class = "factor"),
    yr = 1993, `Extremely Polluted` = 0, `Heavily Polluted` = 0,
    `Meanly Polluted` = 0, `Slightly Polluted` = 0.901098901098901,
    Unpolluted = 0.0989010989010989),
    row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")))

})

test_that("anlz_ambimed row 1 matches expected values for AMBI-TB", {

  result <- anlz_ambimed(ambiscr_tb)[1, ]
  expect_equal(result, structure(list(
    bay_segment = structure(8L, levels = c("OTB", "HB", "MTB", "LTB", "TCB", "MR", "BCB", "All"), class = "factor"),
    yr = 1993, `Extremely Polluted` = 0, `Heavily Polluted` = 0,
    `Meanly Polluted` = 0.043956043956044, `Slightly Polluted` = 0.32967032967033,
    Unpolluted = 0.626373626373626),
    row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")))

})

test_that("anlz_ambimed infers AMBI variant from column names", {

  result_std <- anlz_ambimed(ambiscr)
  result_tb  <- anlz_ambimed(ambiscr_tb)
  expect_s3_class(result_std, 'data.frame')
  expect_s3_class(result_tb, 'data.frame')

})

test_that("anlz_ambimed errors when input lacks AMBICat or TBAMBICat column", {

  expect_error(anlz_ambimed(data.frame(x = 1)))

})

test_that("anlz_ambimed rev = TRUE reverses bay segment factor levels", {

  result_fwd <- anlz_ambimed(ambiscr)
  result_rev <- anlz_ambimed(ambiscr, rev = TRUE)
  expect_equal(levels(result_fwd$bay_segment), rev(levels(result_rev$bay_segment)))

})

test_that("anlz_ambimed window = FALSE runs without error", {

  result <- anlz_ambimed(ambiscr, window = FALSE)
  expect_s3_class(result, 'data.frame')

})

test_that("anlz_ambimed bay_segment filter returns only the requested segment", {

  result <- anlz_ambimed(ambiscr, bay_segment = 'OTB')
  expect_true(all(as.character(result$bay_segment) == 'OTB'))

})

test_that("anlz_ambimed yrrng filters to the requested year range", {

  result <- anlz_ambimed(ambiscr, yrrng = c(2010, 2015))
  expect_true(all(result$yr >= 2010 & result$yr <= 2015))

})

test_that("anlz_ambimed errors on invalid yrrng", {

  expect_error(anlz_ambimed(ambiscr, yrrng = 1998))
  expect_error(anlz_ambimed(ambiscr, yrrng = c(2009, 1997)))

})
