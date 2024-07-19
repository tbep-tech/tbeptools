test_that("Checking anlz_fibmatrix tibble class", {
  result <- anlz_fibmatrix(fibdata)
  expect_is(result, 'tbl')
})

test_that("Checking anlz_fibmatrix station error", {
  expect_error(anlz_fibmatrix(fibdata, stas = '999'), regexp = 'Station(s) not found in fibdata: 999',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station error insufficient data", {
  expect_error(anlz_fibmatrix(fibdata, stas = '616'), regexp = 'Stations with insufficient data for lagyr: 616',
               fixed = T)
})

# Example data
fibdata <- data.frame(
  yr = rep(2000:2005, each = 3),
  epchc_station = rep(letters[1:3], times = 6),
  fcolif = runif(18, 0, 500),
  ecocci = runif(18, 0, 200)
)

test_that("anlz_fibmatrix returns correct structure", {
  result <- anlz_fibmatrix(fibdata)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("yr", "station", "gmean", "cat") %in% names(result)))
})

test_that("anlz_fibmatrix handles default parameters", {
  result <- anlz_fibmatrix(fibdata)
  expect_true(nrow(result) > 0)
  expect_true(all(result$yr >= 2000 & result$yr <= 2005))
})

test_that("anlz_fibmatrix respects custom year range and stations", {
  result <- anlz_fibmatrix(fibdata, yrrng = c(2001, 2004), stas = c("a", "b"))
  expect_true(all(result$yr >= 2001 & result$yr <= 2004))
  expect_true(all(result$station %in% c("a", "b")))
})

test_that("anlz_fibmatrix works with different indicators", {
  result_fcolif <- anlz_fibmatrix(fibdata, indic = "fcolif")
  result_ecocci <- anlz_fibmatrix(fibdata, indic = "ecocci")
  expect_true(nrow(result_fcolif) > 0)
  expect_true(nrow(result_ecocci) > 0)
})

test_that("anlz_fibmatrix respects custom thresholds", {
  result <- anlz_fibmatrix(fibdata, threshold = 200)
  expect_true(nrow(result) > 0)
})

# Test wet/dry subsetting
test_that("anlz_fibmatrix errors if wetdry info is not provided", {
  expect_error(anlz_fibmatrix(enterodata, indic = 'ecocci',
                              lagyr = 1, subset_wetdry = "dry", temporal_window = 2),
               regxp = 'temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples')
})

test_that("wet/dry subsetting inside function works the same as the longer workflow", {
  result_a <- anlz_fibmatrix(enterodata, indic = 'ecocci',
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  sub_b <- anlz_fibwetdry(enterodata, precipdata = catchprecip,
                          temporal_window = 2, wet_threshold = 0.5) %>%
    dplyr::filter(wet_sample == FALSE)
  result_b <- anlz_fibmatrix(sub_b, indic = 'ecocci', lagyr = 1)

  expect_equivalent(result_a, result_b)
  })

test_that("wet/dry subsetting does lead to different data frames", {
  result_a <- anlz_fibmatrix(enterodata, indic = 'ecocci',
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  result_b <- anlz_fibmatrix(enterodata, indic = 'ecocci',
                             lagyr = 1, subset_wetdry = "wet",
                             temporal_window = 2, wet_threshold = 0.5)

  result_c <- anlz_fibmatrix(enterodata, indic = 'ecocci',
                             lagyr = 1)

  expect_failure(expect_equivalent(result_a, result_b))
  expect_failure(expect_equivalent(result_a, result_c))
})
