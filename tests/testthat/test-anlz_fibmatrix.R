test_that("Checking anlz_fibmatrix tibble class", {
  result <- expect_warning(anlz_fibmatrix(fibdata, indic = 'fcolif'))
  expect_is(result, 'tbl')
})

test_that("Checking anlz_fibmatrix station error", {
  expect_error(anlz_fibmatrix(fibdata, indic = 'fcolif', stas = '999'), regexp = 'Station(s) not found in fibdata: 999',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station warning some insufficient data", {
  expect_warning(anlz_fibmatrix(fibdata, indic = 'fcolif', stas = c('115', '616')), regexp = 'Stations with insufficient data for lagyr: 616',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station error all insufficient data", {
  expect_error(anlz_fibmatrix(fibdata, indic = 'fcolif', stas = '616'), regexp = 'Insufficient data for lagyr',
                 fixed = T)
})

# Example data
fibdatatst <- data.frame(
  yr = rep(2000:2005, each = 3),
  epchc_station = rep(letters[1:3], times = 6),
  fcolif = runif(18, 0, 500),
  entero = runif(18, 0, 200)
)

test_that("anlz_fibmatrix returns correct structure", {
  result <- anlz_fibmatrix(fibdatatst, indic = 'fcolif')
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("yr", "station", "gmean", "cat") %in% names(result)))
})

test_that("anlz_fibmatrix handles default parameters", {
  result <- anlz_fibmatrix(fibdatatst, indic = 'fcolif')
  expect_true(nrow(result) > 0)
  expect_true(all(result$yr >= 2000 & result$yr <= 2005))
})

test_that("anlz_fibmatrix respects custom year range and stations", {
  result <- anlz_fibmatrix(fibdatatst, indic = 'fcolif', yrrng = c(2001, 2004), stas = c("a", "b"))
  expect_true(all(result$yr >= 2001 & result$yr <= 2004))
  expect_true(all(result$station %in% c("a", "b")))
})

test_that("anlz_fibmatrix works with different indicators", {
  result_fcolif <- anlz_fibmatrix(fibdatatst, indic = "fcolif")
  result_entero <- anlz_fibmatrix(fibdatatst, indic = "entero")
  expect_true(nrow(result_fcolif) > 0)
  expect_true(nrow(result_entero) > 0)
})

test_that("anlz_fibmatrix respects custom thresholds", {
  result <- anlz_fibmatrix(fibdatatst, indic = 'fcolif', threshold = 200)
  expect_true(nrow(result) > 0)
})

substas <- c("21FLHILL_WQX-101", "21FLHILL_WQX-102", "21FLHILL_WQX-103")

# Test wet/dry subsetting
test_that("anlz_fibmatrix errors if wetdry info is not provided", {
  expect_error(anlz_fibmatrix(enterodata, indic = 'entero', stas = substas,
                              lagyr = 1, subset_wetdry = "dry", temporal_window = 2),
               regxp = 'temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples')
})

test_that("wet/dry subsetting inside function works the same as the longer workflow", {
  result_a <- anlz_fibmatrix(enterodata, indic = 'entero', stas = substas,
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  sub_b <- anlz_fibwetdry(enterodata, precipdata = catchprecip,
                          temporal_window = 2, wet_threshold = 0.5) %>%
    dplyr::filter(wet_sample == FALSE)
  result_b <- anlz_fibmatrix(sub_b, indic = 'entero', stas = substas, lagyr = 1)

  expect_equivalent(result_a, result_b)
})

test_that("wet/dry subsetting does lead to different data frames", {
  result_a <- anlz_fibmatrix(enterodata, indic = 'entero', stas = substas,
                             lagyr = 1, subset_wetdry = "dry",
                             temporal_window = 2, wet_threshold = 0.5)

  result_b <- anlz_fibmatrix(enterodata, indic = 'entero', stas = substas,
                             lagyr = 1)

  expect_failure(expect_equivalent(result_a, result_b))
})

test_that("Check correct error if incorrect bay segment entry", {

  expect_error(anlz_fibmatrix(enterodata, indic = 'entero', bay_segment = c('HB', 'OTB', '999')), regexp = 'Invalid bay_segment(s): 999',
               fixed = T)

})

test_that("Check error if wet/dry is used for epchc data",{

  expect_error(anlz_fibmatrix(fibdata, indic = 'fcolif', subset_wetdry = 'wet'), regexp = 'Subset to wet or dry samples not supported for epchc data',
               fixed = T)

})

test_that("Check error if indic is fcolif for non-epchc data",{

  expect_error(anlz_fibmatrix(enterodata, indic = 'fcolif'), regexp = 'fcolif not a valid indicator for non-epchc data',
               fixed = T)

})

test_that("Check error if bay segment is not null for epchc data", {

  expect_error(anlz_fibmatrix(fibdata, indic = 'fcolif', bay_segment = 'HB'), regexp = 'Bay segment subsetting not applicable for epchc data',
               fixed = T)

})
