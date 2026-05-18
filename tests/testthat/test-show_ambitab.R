test_that("show_ambitab returns a flextable for standard AMBI input", {

  result <- show_ambitab(ambiscr)
  expect_s3_class(result, 'flextable')

})

test_that("show_ambitab returns a flextable for AMBI-TB input", {

  result <- show_ambitab(ambiscr_tb)
  expect_s3_class(result, 'flextable')

})

test_that("show_ambitab has 8 rows: 7 bay segments plus All", {

  result <- show_ambitab(ambiscr)
  expect_equal(nrow(result$body$dataset), 8L)

})

test_that("show_ambitab last row is All", {

  result <- show_ambitab(ambiscr)
  expect_equal(result$body$dataset$Segment[8], 'All')

})

test_that("show_ambitab columns include n and all five AMBI categories", {

  result <- show_ambitab(ambiscr)
  expect_true(all(c('Segment', 'n', 'Extremely Polluted', 'Heavily Polluted',
                     'Meanly Polluted', 'Slightly Polluted', 'Unpolluted')
                   %in% names(result$body$dataset)))

})

test_that("show_ambitab row percentages sum to 100 for each segment", {

  dat <- show_ambitab(ambiscr)$body$dataset
  cat_cols <- c('Extremely Polluted', 'Heavily Polluted', 'Meanly Polluted',
                'Slightly Polluted', 'Unpolluted')
  row_sums <- rowSums(dat[, cat_cols])
  expect_true(all(abs(row_sums - 100) < 1e-6))

})

test_that("show_ambitab bay_segment filter returns only requested segments", {

  result <- show_ambitab(ambiscr, bay_segment = c('OTB', 'HB'))
  segs <- result$body$dataset$Segment
  expect_true(all(segs %in% c('OTB', 'HB', 'All')))
  expect_equal(nrow(result$body$dataset), 3L)

})

test_that("show_ambitab yrrng filters reduce total site count", {

  full <- show_ambitab(ambiscr)$body$dataset
  sub  <- show_ambitab(ambiscr, yrrng = c(2010, 2020))$body$dataset
  expect_true(sub[sub$Segment == 'All', 'n'] < full[full$Segment == 'All', 'n'])

})

test_that("show_ambitab accepts a single yrrng value", {

  result <- show_ambitab(ambiscr, yrrng = 2010)
  expect_s3_class(result, 'flextable')

})

test_that("show_ambitab errors on invalid yrrng", {

  expect_error(show_ambitab(ambiscr, yrrng = c(2010, 2005)))

})

test_that("show_ambitab errors when input lacks AMBICat or TBAMBICat column", {

  expect_error(show_ambitab(data.frame(x = 1)))

})
