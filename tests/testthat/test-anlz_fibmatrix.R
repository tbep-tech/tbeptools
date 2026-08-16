test_that("Checking anlz_fibmatrix tibble class", {
  result <- anlz_fibmatrix(fibdata)
  expect_is(result, 'tbl')
})

test_that("Checking anlz_fibmatrix station error", {
  expect_error(anlz_fibmatrix(fibdata, stas = '999'), regexp = 'Station(s) not found in fibdata: 999',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station warning some insufficient data", {
  expect_warning(anlz_fibmatrix(fibdata, stas = c('634', '19')), regexp = 'Stations with insufficient data for lagyr: 634',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station error all insufficient data", {
  expect_error(anlz_fibmatrix(fibdata, stas = '634'), regexp = 'Insufficient data for lagyr',
                 fixed = T)
})

# Example data
fibdatatst <- data.frame(
  epchc_station = c('a', 'b', 'c'),
  Latitude = runif(3, 27, 28),
  Longitude = runif(3, -82, -81),
  class = '3M',
  area = 'FL'
  ) %>%
  tidyr::crossing(
    yr = rep(2000:2005),
    mo = rep(1:12)
  ) %>%
  mutate(
    entero = runif(n(), 0, 200),
    ecoli = runif(n(), 4, 500)
  )

test_that("Checking anlz_fibmatrix station warning for insufficient data", {
  datchk <- fibdatatst %>%
    filter(!(epchc_station == 'a' & yr %in% c(2000:2003)))
  expect_warning(anlz_fibmatrix(datchk, stas = c('a', 'b', 'c')), regexp = 'Stations with insufficient data for lagyr: a',
               fixed = T)
})

test_that("anlz_fibmatrix returns correct structure", {
  result <- anlz_fibmatrix(fibdatatst, stas = c("a", "b", "c"))
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("yr", "class", "grp", "gmean", "cat", "nexceed", "nsamp", "exceed_rate") %in% names(result)))
})

test_that("anlz_fibmatrix exceed_rate matches the qbeta formula and is consistent with cat", {
  result <- anlz_fibmatrix(fibdata) %>%
    dplyr::filter(!is.na(cat))

  expect_equal(
    result$exceed_rate,
    stats::qbeta(0.10, result$nexceed, result$nsamp - result$nexceed + 1)
  )

  # exceed_rate should be exactly the threshold rate (10/30/50/75%) right at
  # a category boundary, and should increase monotonically with the letter
  # grade (A best/lowest, E worst/highest) on average
  avgs <- result %>%
    dplyr::summarise(m = mean(exceed_rate), .by = 'cat') %>%
    dplyr::arrange(factor(cat, levels = c('A', 'B', 'C', 'D', 'E')))

  expect_equal(avgs$m, sort(avgs$m))
})

test_that("anlz_fibmatrix exceed_rate reproduces the binomial test at 0.10 significance", {
  result <- anlz_fibmatrix(fibdata) %>%
    # nexceed = 0 is a degenerate boundary case (the tail probability is
    # always 1 regardless of the assumed rate, so exceed_rate is fixed at 0
    # rather than solving the 0.10 equation) - excluded here, checked below
    dplyr::filter(!is.na(cat), nexceed > 0)

  chk <- pbinom(result$nexceed - 1, result$nsamp, result$exceed_rate, lower.tail = FALSE)
  expect_equal(chk, rep(0.10, length(chk)), tolerance = 1e-6)
})

test_that("anlz_fibmatrix exceed_rate is 0 when there are no exceedances", {
  result <- anlz_fibmatrix(fibdata) %>%
    dplyr::filter(!is.na(cat), nexceed == 0)

  expect_true(nrow(result) > 0)
  expect_true(all(result$exceed_rate == 0))
  expect_true(all(result$cat == 'A'))
})

test_that("anlz_fibmatrix handles default parameters", {
  result <- anlz_fibmatrix(fibdatatst, stas = c("a", "b", "c"))
  expect_true(nrow(result) > 0)
  expect_true(all(result$yr >= 2000 & result$yr <= 2005))
})

test_that("anlz_fibmatrix respects custom year range and stations", {
  result <- anlz_fibmatrix(fibdatatst, yrrng = c(2001, 2004), stas = c("a", "b"))
  expect_true(all(result$yr >= 2001 & result$yr <= 2004))
  expect_true(all(result$grp %in% c("a", "b")))
})

substas <- c("21FLHILL_WQX-101", "21FLHILL_WQX-102", "21FLHILL_WQX-103")

# Test wet/dry subsetting
test_that("anlz_fibmatrix errors if wetdry info is not provided", {
  expect_error(anlz_fibmatrix(enterodata, stas = substas,
                              lagyr = 1, subset_wetdry = "dry", temporal_window = 2),
               regexp = 'temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples')
})

test_that("wet/dry subsetting inside function works the same as the longer workflow", {
  result_a <- anlz_fibmatrix(enterodata, stas = substas,
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  sub_b <- anlz_fibwetdry(enterodata, precipdata = catchprecip,
                          temporal_window = 2, wet_threshold = 0.5) %>%
    dplyr::filter(wet_sample == FALSE)
  result_b <- anlz_fibmatrix(sub_b, stas = substas, lagyr = 1)

  expect_equivalent(result_a, result_b)
})

test_that("wet/dry subsetting does lead to different data frames", {
  result_a <- anlz_fibmatrix(enterodata, stas = substas,
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  result_b <- anlz_fibmatrix(enterodata, stas = substas,
                             lagyr = 1)

  expect_failure(expect_equivalent(result_a, result_b))
})

test_that("Check correct error if incorrect bay segment entry", {

  expect_error(anlz_fibmatrix(enterodata, bay_segment = c('HB', 'OTB', '999')), regexp = 'Invalid bay_segment(s): 999',
               fixed = T)

})

test_that("Check error if wet/dry is used for epchc data",{

  expect_error(anlz_fibmatrix(fibdata, subset_wetdry = 'wet'), regexp = 'Subset to wet or dry samples not supported for epchc data',
               fixed = T)

})

test_that("Check error if wet/dry is used for County data",{

  expect_error(anlz_fibmatrix(mancofibdata, subset_wetdry = 'wet'), regexp = 'Subset to wet or dry samples not supported for County data',
               fixed = T)

})

test_that("Check error if bay segment is not null for epchc data", {

  expect_error(anlz_fibmatrix(fibdata, bay_segment = 'HB'), regexp = 'Bay segment subsetting not applicable for epchc data',
               fixed = T)

})

test_that("Check error if bay segment is not null for County data", {

  expect_error(anlz_fibmatrix(mancofibdata, bay_segment = 'Manatee River'), regexp = 'Bay segment subsetting not applicable for County data',
               fixed = T)

})

test_that("Checking anlz_fibmatrix if bay segment is not null for non-epchc data", {
  result <- anlz_fibmatrix(enterodata, bay_segment = 'HB')
  expect_true('HB' %in% result$grp)
})

test_that("Checking anlz_fibmatrix if bay segment is null and stas is null for non-epchc data", {
  result <- suppressWarnings(anlz_fibmatrix(enterodata))
  expect_true(any(grepl('FLHILL', result$grp)))
})

test_that("Checking anlz_fibmatrix yrrng[1] as NA", {
  result <- anlz_fibmatrix(fibdata, yrrng = c(NA, 2020))
  expect_true(min(result$yr) < 2020)
})

test_that("Checking anlz_fibmatrix yrrng[2] as NA", {
  result <- anlz_fibmatrix(fibdata, yrrng = c(2010, NA))
  expect_true(max(result$yr) > 2010)
})
