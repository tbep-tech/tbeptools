test_that("Check output class for anlz_hydroload", {

  noaa_key <- Sys.getenv('NOAA_KEY')
  result <- try({anlz_hydroload(2021, noaa_key, trace = T)}, silent = T)

  # sometimes 503 error is returned
  while(inherits(result, 'try-error')){
    Sys.sleep(10)
    result <- try({anlz_hydroload(2021, noaa_key, trace = T)}, silent = T)
  }

  expect_s3_class(result, 'tbl_df')
  expect_equal(result$`Adjusted?`[1], 'YES')

})
