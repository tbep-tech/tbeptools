test_that("Check output class for anlz_hydroload", {

  noaa_key <- Sys.getenv('NOAA_KEY')
  result <- anlz_hydroload(2021, noaa_key)

  expect_s3_class(result, 'tbl_df')
  expect_equal(result$`Adjusted?`[1], 'YES')

})
