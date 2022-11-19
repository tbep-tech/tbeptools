test_that("Checking anlz_hmpreport class", {
  result <- anlz_hmpreport(acres, subtacres, hmptrgs)
  expect_s3_class(result, 'tbl_df')
})
