test_that("Checking class on anlz_hydroload", {

  noaa_key <- Sys.getenv("NOAA_KEY")
  if(noaa_key == '')
    noaa_key <- NULL
  result <- anlz_hydroload(2019, noaa_key)

  expect_is(result, 'data.frame')

})
