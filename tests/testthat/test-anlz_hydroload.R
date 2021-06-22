test_that("Checking class on anlz_hydroload", {

  noaa_key <- Sys.getenv("NOAA_KEY")
  result <- anlz_hydroload(2019, noaa_key)

  expect_is(result, 'data.frame')

})
