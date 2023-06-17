test_that("Check output class for util_html", {

  result <- util_html('abc')
  expect_s3_class(result, 'html')

})
